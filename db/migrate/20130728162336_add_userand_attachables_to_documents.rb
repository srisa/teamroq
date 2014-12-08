class AddUserandAttachablesToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :user_id, :integer
    add_column :documents, :attachable_type, :string
    add_column :documents, :attachable_id, :integer
  end
end
