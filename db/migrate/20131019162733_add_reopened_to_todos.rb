class AddReopenedToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :reopened_on, :datetime
  end
end
