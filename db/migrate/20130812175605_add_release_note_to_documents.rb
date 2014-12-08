class AddReleaseNoteToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :release_note, :string
  end
end
