class AddDetailsToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :details, :string
  end
end
