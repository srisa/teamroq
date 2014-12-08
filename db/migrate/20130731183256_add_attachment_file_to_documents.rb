class AddAttachmentFileToDocuments < ActiveRecord::Migration
  def self.up
    change_table :documents do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :documents, :file
  end
end
