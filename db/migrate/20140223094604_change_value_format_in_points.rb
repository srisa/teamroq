class ChangeValueFormatInPoints < ActiveRecord::Migration
  def up
    change_column :points, :value, :decimal
  end

  def down
    change_column :points, :value, :integer
  end
end
