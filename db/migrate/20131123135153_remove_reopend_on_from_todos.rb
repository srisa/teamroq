class RemoveReopendOnFromTodos < ActiveRecord::Migration
  def change
    remove_column :todos, :reopened_on
  end
end
