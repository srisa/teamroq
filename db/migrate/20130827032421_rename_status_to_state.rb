class RenameStatusToState < ActiveRecord::Migration
  def up
  	rename_column :todos, :status ,:state
  end

  def down
  	rename_column :todos, :state ,:status
  end
end
