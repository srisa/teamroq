class AddActableToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :actable_type, :string
    add_column :activities, :actable_id, :integer
  end
end
