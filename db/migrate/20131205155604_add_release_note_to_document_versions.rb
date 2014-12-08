class AddReleaseNoteToDocumentVersions < ActiveRecord::Migration
  def change
    add_column :document_versions, :release_note, :string
  end
end
