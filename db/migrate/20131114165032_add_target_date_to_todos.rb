class AddTargetDateToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :target_date, :date
  end
end
