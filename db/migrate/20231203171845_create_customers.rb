# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :ip
      t.integer :votes_count, default: 0

      t.timestamps
    end
  end
end
