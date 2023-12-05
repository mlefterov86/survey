# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    content { Faker::Lorem.sentence }
  end
end
