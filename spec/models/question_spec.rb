# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:poll) { FactoryBot.create(:poll) }
  let(:question) { FactoryBot.create(:question) }

  describe 'associations' do
    it { should have_and_belong_to_many(:polls) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:customers).through(:votes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'class methods' do
    describe '.ransackable_attributes' do
      it 'returns an array of ransackable attributes' do
        expect(described_class.ransackable_attributes).to match_array(%w[content created_at updated_at])
      end
    end

    describe '.ransackable_associations' do
      it 'returns an array of ransackable associations' do
        expect(described_class.ransackable_associations).to match_array(%w[customers polls votes])
      end
    end
  end

  describe 'callbacks' do
    it 'clears polls association before destroying' do
      question.polls << poll

      expect { question.destroy }.to change { question.polls.count }.from(1).to(0)
    end
  end
end
