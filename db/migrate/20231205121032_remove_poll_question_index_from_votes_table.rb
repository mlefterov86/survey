class RemovePollQuestionIndexFromVotesTable < ActiveRecord::Migration[7.1]
  def change
    remove_index :votes, column: %i[poll_id question_id]
  end
end
