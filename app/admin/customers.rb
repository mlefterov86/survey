# frozen_string_literal: true

ActiveAdmin.register Customer do
  menu priority: 4

  includes :votes
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
      table_for resource.polls do
        column 'Polls voted', :title do |poll|
          link_to poll.title, admin_poll_path(poll)
        end
      end
    end
  end

  controller do
    actions :all, except: %i[edit update destroy]
  end
end
