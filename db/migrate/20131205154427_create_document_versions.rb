class CreateDocumentVersions < ActiveRecord::Migration
  def change
    create_table :document_versions do |t|
      t.references :document

      t.timestamps
    end
    add_index :document_versions, :document_id
  end
end
