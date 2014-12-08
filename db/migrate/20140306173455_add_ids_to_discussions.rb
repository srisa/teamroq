class AddIdsToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :user_id, :integer
    add_index :discussions, :user_id
    add_column :discussions, :discussable_type, :string
    add_column :discussions, :discussable_id, :integer
    add_index :discussions, :discussable_id
  end
end
