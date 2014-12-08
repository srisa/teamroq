class AddIndicesToArrays < ActiveRecord::Migration
  def change
    add_index :users, :followers, using: 'gin'
    add_index :users, :feed, using: 'gin'
  	add_index :users, :notifications, using: 'gin'
  	add_index :questions, :followers, using: 'gin'
  	add_index :questions, :up_votes, using: 'gin'
  	add_index :questions, :down_votes, using: 'gin'
  	add_index :answers, :up_votes, using: 'gin'
  	add_index :answers, :down_votes, using: 'gin'
  	add_index :discussions, :followers, using: 'gin'
  	add_index :todos, :followers, using: 'gin'
    add_index :tags, :followers, using: 'gin'
  	add_index :posts, :followers, using: 'gin'
  end
end
