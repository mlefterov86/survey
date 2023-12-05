# frozen_string_literal: true

FactoryBot.define do
  factory :poll do
    sequence(:title) { |n| "Poll #{n}" }
  end
end
