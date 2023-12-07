# frozen_string_literal: true

class CreatePolls < ActiveRecord::Migration[7.1]
  def change
    create_table :polls do |t|
      t.string :title
      t.integer :state, default: 0, index: true, null: false

      t.timestamps
    end
  end
end
