# frozen_string_literal: true

ActiveAdmin.register Customer do
  menu priority: 4

  filter :ip
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :ip do |customer|
      link_to customer.ip, admin_customer_path(customer)
    end
    column :votes_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :ip
      row :created_at
      row :votes_count
      table_for resource.votes do
        column 'Poll voted', :poll_id do |vote|
          link_to vote.poll.title, admin_poll_path(vote.poll_id)
        end
        column 'Chosen Question', :poll_id do |vote|
          link_to vote.question.content, admin_question_path(vote.question_id)
        end
      end
    end
  end

  controller do
    actions :all, except: %i[edit update destroy]

    def scoped_collection
      Customer.includes(:polls, :questions)
    end
  end
end
