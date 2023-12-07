# frozen_string_literal: true

FactoryBot.define do
  factory :poll do
    sequence(:title) { |n| "Poll #{n}" }

    trait :published do
      state { 10 }
    end

    trait :with_questions do
      after(:create) do |poll, _evaluator|
        poll.questions << [FactoryBot.create(:question), FactoryBot.create(:question)]
        poll.save!
      end
    end
  end
end
