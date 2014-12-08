class RemoveDescriptionFromTodos < ActiveRecord::Migration
  def change
    remove_column :todos, :description
  end
end
