class AddAttachmentsToDocumentVersions < ActiveRecord::Migration
  def self.up
    change_table :document_versions do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :document_versions, :file
  end
end
