# frozen_string_literal: true

ActiveAdmin.register Question do
  menu priority: 3

  includes :polls
  filter :content
  filter :created_at
  filter :updated_at

  permit_params :content

  index do
    selectable_column
    column :content do |q|
      link_to q.content, admin_question_path(q)
    end
    column 'Editable (not assigned to a poll)' do |question|
      question.polls.none?
    end
    actions
  end

  show do
    attributes_table do
      row :content
      row :created_at
      table_for resource.polls do
        column 'Polls having current question', :title do |poll|
          link_to poll.title, admin_poll_path(poll)
        end
      end
    end
  end

  controller do
    before_action :check_edit_permission, only: %i[edit update]

    private

    def check_edit_permission
      return unless resource.polls.any?

      flash[:error] = 'Editing is not allowed questions associated with polls'
      redirect_to admin_questions_path
    end
  end
end
