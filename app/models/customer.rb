# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :polls, through: :votes
  has_many :questions, through: :votes

  validates :ip, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[ip created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[polls questions votes]
  end
end
