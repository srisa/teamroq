class AddReferencableToDocuments < ActiveRecord::Migration
  def change
  	change_table :documents do |t|
  		t.references :referencable, :polymorphic=> true
    end
    add_index :documents , :referencable_id
    add_index :documents , :referencable_type
  end
end
