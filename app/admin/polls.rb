# frozen_string_literal: true

ActiveAdmin.register Poll do
  menu priority: 2
  filter :title
  filter :state
  filter :created_at
  filter :updated_at

  permit_params :id, :title, :state, question_ids: []

  action_item :view, except: :index do
    link_to 'Visit poll', poll_path(resource) if resource.published?
  end

  index do
    selectable_column
    column :title do |poll|
      link_to poll.title, admin_poll_path(poll)
    end
    column :state
    column :total_votes, &:total_votes
    column :total_questions, &:total_questions
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :state
      row :total_votes, &:total_votes
      row :questions, &:total_questions
      row :created_at

      table_for poll.questions do
        column 'Questions', :content do |question|
          link_to question.content, admin_question_path(question)
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs 'Details' do
      f.input :title
      f.input :state
      f.input :questions, as: :check_boxes, collection: questions_collection
    end
    f.actions
  end

  controller do
    helper_method :questions_collection

    def scoped_collection
      Poll
        .left_joins(:questions)
        .left_joins(:votes)
        .select('polls.*, COUNT(DISTINCT votes.id) AS total_votes,  COUNT(DISTINCT questions.id) AS total_questions')
        .group('polls.id')
    end

    def questions_collection
      @questions_collection ||= Question.all.map do |qc|
        [qc.content, qc.id]
      end
    end

    def create
      poll = Poll.new
      store_resource(poll)
      if poll.persisted?
        redirect_to(admin_poll_path(poll), notice: :success)
      else
        super
      end
    end

    def update
      if store_resource(resource) # rubocop:disable Style/GuardClause
        redirect_to(admin_poll_path(resource), notice: :success)
      else
        render :edit and return
      end
    end

    private

    def store_resource(poll)
      ActiveRecord::Base.transaction do
        poll.assign_attributes(permitted_params[:poll])

        if new_questions(permitted_questions_ids).present?
          poll.questions.destroy_all if poll.questions.any?
          poll.questions << new_questions(permitted_questions_ids)
        end
        poll.save!
      end
    rescue StandardError
      false
    end

    def permitted_questions_ids
      permitted_params[:poll][:question_ids].map(&:presence).compact
    end

    def new_questions(ids)
      @new_questions ||= Question.where(id: ids)
    end
  end
end
