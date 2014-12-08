class AddClosedOnToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :closed_on, :datetime
  end
end
