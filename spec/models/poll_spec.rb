# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Poll, type: :model do
  let(:poll) { FactoryBot.create(:poll) }

  describe 'associations' do
    it { should have_and_belong_to_many(:questions) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:customers).through(:votes) }
  end

  describe 'enums' do
    it { should define_enum_for(:state).with_values(created: 0, published: 10, archived: 20) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).case_insensitive }

    context 'custom validation' do
      describe '#poll_editable' do
        let(:poll) { FactoryBot.create(:poll) }

        context 'when valid' do
          it 'is valid when state is created' do
            expect(poll).to be_valid
          end

          it 'is valid when state is archived' do
            poll.archived!
            poll.title = 'New title'
            expect(poll).to be_valid
          end
        end

        it 'is invalid when state is published' do
          poll.published!
          poll.title = 'New title'
          expect(poll).to be_invalid
          expect(poll.errors[:base]).to include('Unable to edit a `published` poll')
        end
      end
    end
  end

  describe 'custom methods' do
    let(:question1) { FactoryBot.create(:question) }
    let(:question2) { FactoryBot.create(:question) }

    before do
      poll.questions << [question1, question2]
      poll.save!
    end

    describe '#total_questions' do
      it 'returns the count of associated questions' do
        expect(poll.total_questions).to eq(2)
      end
    end

    describe '#total_votes' do
      let(:customer) { FactoryBot.create(:customer) }

      before do
        FactoryBot.create(:vote, poll:, customer:, question: question1)
      end

      it 'returns the count of associated votes' do
        expect(poll.total_votes).to eq(1)
      end
    end
  end

  describe 'callbacks' do
    it 'clears questions association before destroying' do
      question = FactoryBot.create(:question)
      poll.questions << question

      expect { poll.destroy }.to change { poll.questions.count }.from(1).to(0)
    end
  end

  describe 'ransackable_attributes' do
    it 'returns an array of ransackable attributes' do
      expect(described_class.ransackable_attributes).to match_array(%w[title created_at updated_at])
    end
  end

  describe 'ransackable_associations' do
    it 'returns an array of ransackable associations' do
      expect(described_class.ransackable_associations).to match_array(%w[customers questions votes])
    end
  end
end
