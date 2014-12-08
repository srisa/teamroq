class ChangeContentDataTypeInTodos < ActiveRecord::Migration
  def up
    change_column :todos, :details, :text
  end

  def down
    change_column :todos, :details, :string
  end
end
