class AddSlugToModels < ActiveRecord::Migration
  def change
    remove_index :users, :slug
    add_index :users, :slug
    add_column :projects, :slug, :string
    add_index :projects, :slug
    add_column :todos, :slug, :string
    add_index :todos, :slug 
    add_column :todo_lists, :slug, :string
    add_index :todo_lists, :slug 
    add_column :questions, :slug, :string
    add_index :questions, :slug  
  end
end
