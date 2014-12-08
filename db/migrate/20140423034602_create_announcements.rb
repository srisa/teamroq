class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.text :content
      t.integer :announcable_id
      t.string :announcable_type

      t.timestamps
    end
    add_index :announcements, :announcable_id
  end
end
