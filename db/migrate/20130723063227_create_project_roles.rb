class CreateProjectRoles < ActiveRecord::Migration
  def change
    create_table :project_roles do |t|
      t.belongs_to :user
      t.belongs_to :project

      t.timestamps
    end
    add_index :project_roles, :user_id
    add_index :project_roles, :project_id
  end
end
