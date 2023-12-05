# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.references :customer, foreign_key: true
      t.references :poll, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end

    add_index :votes, %i[customer_id poll_id], unique: true
    add_index :votes, %i[poll_id question_id], unique: true
  end
end
