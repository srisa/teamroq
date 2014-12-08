class AddArraysToModels < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.integer :followers, :array => true, default: []
      t.integer :feed, :array => true, default: []
  		t.integer :notifications, :array => true, default: []
  	end
  	change_table :questions do |t|
  		t.integer :followers, :array => true, default: []
  		t.integer :up_votes, :array => true, default: []
  		t.integer :down_votes, :array => true, default: []
  	end
  	change_table :answers do |t|
  		t.integer :up_votes, :array => true, default: []
  		t.integer :down_votes, :array => true, default: []
  	end
  	change_table :discussions do |t|
  		t.integer :followers, :array => true, default: []
  	end
  	change_table :todos do |t|
  		t.integer :followers, :array => true, default: []
  	end
  	change_table :tags do |t|
  		t.integer :followers, :array => true, default: []
  	end
    change_table :posts do |t|
      t.integer :followers, :array => true, default: []
    end
  end
end
