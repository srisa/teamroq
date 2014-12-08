class AddDefaultValueForVotes < ActiveRecord::Migration
  def change
  	change_column :questions, :votes, :integer, default: 0
  end
end
