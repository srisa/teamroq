class RemoveAttachmentAndReleaseNoteFromDocuments < ActiveRecord::Migration
  def change
    drop_attached_file :documents, :file
    remove_column :documents, :release_note
  end
end
