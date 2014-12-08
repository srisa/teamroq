class AddPathToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :path, :string
  end
end
