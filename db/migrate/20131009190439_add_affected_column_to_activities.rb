class AddAffectedColumnToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :affected_type, :string
    add_column :activities, :affected_id, :integer
  end
end
