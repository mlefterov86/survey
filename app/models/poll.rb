# frozen_string_literal: true

class Poll < ApplicationRecord
  attr_accessor :question_ids

  has_and_belongs_to_many :questions
  has_many :votes, dependent: :destroy
  has_many :customers, through: :votes

  enum state: {
    created: 0,
    published: 10,
    archived: 20
  }

  before_destroy { questions.clear }

  validates :title, presence: true, uniqueness: true
  validate :poll_editable
  validate :can_publish
  validate :publish_new_record

  # Finds a `Poll`, joining poll's `Vote`s, including total poll's votes
  scope :find_by_id, lambda { |id|
    model.name.constantize
         .left_joins(:votes)
         .select('polls.*, COUNT(votes.id) AS votes_count')
         .group('polls.id')
         .where(id:)
  }

  # Finds poll's `Question`s, joining poll's `Vote`s, including total votes for each question
  scope :questions_for, lambda { |poll|
    return [] unless poll.present?

    poll.questions
        .joins(
          <<~SQL
            LEFT OUTER JOIN `votes`
            ON `votes`.`question_id` = `questions`.`id`
            AND `votes`.`poll_id` = `polls_questions`.`poll_id`
          SQL
        )
        .select('questions.*, COUNT(votes.id) AS question_votes')
        .group('questions.id')
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[title state created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customers questions votes]
  end

  private

  # I have the assumption that once a poll is `published` cannot be modified after
  def poll_editable
    return if %w[created archived].include?(state_was) || created? || archived?

    errors.add(:base, 'Unable to edit a `published` poll')
  end

  def publish_new_record
    return unless publishing? && new_record?

    errors.add(:base, 'Publishing a new poll not allowed')
  end

  def can_publish
    return unless publishing?

    errors.add(:base, 'Publishing a poll requires more than one question') if questions.count <= 1
  end

  def publishing?
    state_was != 'published' && published?
  end
end
