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

        context 'when poll is published' do
          let(:poll) { FactoryBot.create(:poll, :with_questions) }

          before { poll.published! }

          it 'is invalid when state is published' do
            poll.title = 'New title'
            expect(poll).to be_invalid
            expect(poll.errors[:base]).to include('Unable to edit a `published` poll')
          end
        end
      end

      describe '#publish_new_record' do
        let(:poll) { FactoryBot.build(:poll, :published) }

        it 'expected to be invalid' do
          expect(poll).to be_invalid
          expect(poll.errors[:base]).to include('Publishing a new poll not allowed')
        end
      end

      describe '#can_publish' do
        before do
          poll.questions << FactoryBot.create(:question)
          poll.state = 10
        end

        it 'expected to be invalid' do
          expect(poll).to be_invalid
          expect(poll.errors[:base]).to include('Publishing a poll requires more than one question')
        end
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

  describe 'scopes' do
    let(:poll) { FactoryBot.create(:poll, :with_questions) }

    before do
      2.times do
        FactoryBot.create(:vote, poll:, question: poll.questions[rand(2)])
      end
    end

    describe '.find_by_id' do
      subject(:poll_by_id) { Poll.find_by_id(poll.id).first }

      it 'returns a poll with votes count for a given id' do
        expect(poll_by_id.votes_count).to eq 2
      end
    end

    describe '.questions_for' do
      subject(:poll_questions) { Poll.questions_for(poll) }

      it "returns a poll with questions, including question's votes for a given `Poll`" do
        poll_questions.each do |question|
          expect(question.question_votes).to eq Vote.where(question:).count
        end
      end
    end
  end

  describe 'ransackable_attributes' do
    it 'returns an array of ransackable attributes' do
      expect(described_class.ransackable_attributes).to match_array(%w[title state created_at updated_at])
    end
  end

  describe 'ransackable_associations' do
    it 'returns an array of ransackable associations' do
      expect(described_class.ransackable_associations).to match_array(%w[customers questions votes])
    end
  end
end
