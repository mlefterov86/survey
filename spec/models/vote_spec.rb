# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to(:customer).counter_cache(true) }
    it { should belong_to(:poll) }
    it { should belong_to(:question) }
  end

  describe 'validations' do
    let!(:existing_vote) { FactoryBot.create(:vote) } # Ensure an existing vote for testing uniqueness
    let!(:poll) { existing_vote.poll }

    before do
      poll.questions << [existing_vote.question]
      poll.save!
    end

    it { should validate_presence_of(:customer) }
    it { should validate_uniqueness_of(:customer).scoped_to(:poll_id) }

    it { should validate_presence_of(:question) }
    it { should validate_uniqueness_of(:question).scoped_to(:customer_id, :poll_id) }
  end
end
