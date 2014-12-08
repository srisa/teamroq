class AddVotesToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :votes, :integer
    add_index :questions, :votes
  end
end
