# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :customer, counter_cache: true
  belongs_to :poll
  belongs_to :question

  validates :customer, presence: true, uniqueness: { scope: :poll_id }
  validates :question, presence: true, uniqueness: { scope: %i[customer_id poll_id] }
end
