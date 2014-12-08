class AddDesignationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :designation, :string
  end
end
