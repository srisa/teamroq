class CreateGroupRoles < ActiveRecord::Migration
  def change
    create_table :group_roles do |t|
      t.belongs_to :group
      t.belongs_to :user

      t.timestamps
    end
    add_index :group_roles, :group_id
    add_index :group_roles, :user_id
  end
end
