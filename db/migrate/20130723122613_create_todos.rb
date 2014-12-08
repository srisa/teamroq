class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :name
      t.belongs_to :todo_list

      t.timestamps
    end
    add_index :todos, :todo_list_id
  end
end
