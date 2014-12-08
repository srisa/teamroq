class RemoveRoleFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :role
  end

  def down
    add_columns :users, :role
  end
end
