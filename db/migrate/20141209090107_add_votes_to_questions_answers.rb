class AddVotesToQuestionsAnswers < ActiveRecord::Migration
  def change
    add_column :questions, :votes, :integer
    add_column :answers, :votes, :integer
    add_index :questions, :votes
    add_index :answers, :votes
  end
end
