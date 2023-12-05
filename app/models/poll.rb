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

  def self.ransackable_attributes(_auth_object = nil)
    %w[title created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customers questions votes]
  end

  def total_questions
    questions.count
  end

  def total_votes
    votes.count
  end

  private

  def poll_editable
    return if state_was == 'created' || created? || archived?

    errors.add(:base, 'Unable to edit a `published` poll')
  end
end
