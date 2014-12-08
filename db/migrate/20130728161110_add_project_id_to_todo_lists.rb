class AddProjectIdToTodoLists < ActiveRecord::Migration
  def change
    add_column :todo_lists, :project_id, :integer
  end
end
