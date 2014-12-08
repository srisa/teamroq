class AddMoreFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :desk, :string
  end
end
