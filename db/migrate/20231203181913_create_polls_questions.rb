class CreatePollsQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :polls_questions do |t|
      t.belongs_to :poll
      t.belongs_to :question

      t.timestamps
    end
  end
end
