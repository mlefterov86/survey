# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Polls' do
          ul do
            Poll.last(5).map do |poll|
              li link_to(poll.title, admin_poll_path(poll))
            end
          end
        end
      end
    end
  end
end
