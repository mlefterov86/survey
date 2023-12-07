# frozen_string_literal: true

class Question < ApplicationRecord
  attr_accessor :polls_ids

  has_and_belongs_to_many :polls
  has_many :votes, dependent: :destroy
  has_many :customers, through: :votes

  before_destroy { polls.clear }

  validates :content, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[content created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customers polls votes]
  end
end
