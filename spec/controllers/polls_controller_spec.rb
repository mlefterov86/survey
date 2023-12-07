# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PollsController, type: :controller do
  let(:poll) { FactoryBot.create(:poll, :with_questions) }

  before { poll.published! }

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: poll.id }
      expect(response).to render_template('show')
    end

    it 'assigns the correct poll and questions' do
      get :show, params: { id: poll.id }
      expect(assigns(:poll)).to eq(poll)
      expect(assigns(:questions)).to eq(poll.questions)
    end

    context 'when poll is not published' do
      before { poll.created! }

      it 'renders the not_found template' do
        get :show, params: { id: poll.id }
        expect(response).to render_template('not_found')
      end
    end

    context 'when poll is not found' do
      it 'renders the not_found template' do
        get :show, params: { id: 'nonexistent_id' }
        expect(response).to render_template('not_found')
      end
    end
  end

  describe 'POST #vote' do
    it 'creates a new vote and redirects to the poll path' do
      post :vote, params: { id: poll.id, question_id: poll.questions.first.id }
      expect(response).to redirect_to(poll_path(poll))
      expect(Vote.count).to eq(1)
    end

    it 'finds or creates a customer based on the remote IP' do
      expect do
        post :vote, params: { id: poll.id, question_id: poll.questions.first.id }
      end.to change(Customer, :count).by(1)
    end
  end
end
