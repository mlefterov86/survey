# frozen_string_literal: true

ActiveAdmin.register Poll do
  menu priority: 2
  filter :title
  filter :created_at
  filter :updated_at

  includes :votes, :questions

  permit_params :id, :title, :questions_limit, :state, question_ids: []

  index do
    selectable_column
    column :title do |poll|
      link_to poll.title, admin_poll_path(poll)
    end
    column :state
    column :total_votes, &:total_votes
    column :questions, &:total_questions
    column :questions_limit
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :state
      row :total_votes, &:total_votes
      row :questions, &:total_questions
      row :questions_limit
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
      f.input :questions_limit
      f.input :questions, as: :check_boxes, collection: questions_collection
    end
    f.actions
  end

  controller do
    helper_method :questions_collection

    def questions_collection
      @questions_collection ||= Question.all.map do |qc|
        [qc.content, qc.id]
      end
    end

    def update
      update_resources!

      redirect_to admin_poll_path(resource), notice: :success
    rescue StandardError
      super do
        flash[:notice] = 'Post was successfully updated.' and return if resource.valid?
      end
    end

    private

    def update_resources!
      ActiveRecord::Base.transaction do
        resource.assign_attributes(permitted_params[:poll])
        new_questions = find_questions(permitted_questions_ids)
        if new_questions.present?
          resource.questions.destroy_all
          resource.questions << new_questions
        end
        resource.save!
      end
    end

    def permitted_questions_ids
      permitted_params[:poll][:question_ids].map(&:presence).compact
    end

    def find_questions(ids)
      Question.where(id: ids)
    end
  end
end
