class AddPostableToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :postable_id, :integer
    add_column :posts, :postable_type, :string
  end
end
