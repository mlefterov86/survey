# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    customer { FactoryBot.create(:customer) }
    question { FactoryBot.create(:question) }
    poll { FactoryBot.create(:poll) }
  end
end
