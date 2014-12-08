class ChangePostDataTypeInPosts < ActiveRecord::Migration
  def up
    change_column :posts, :content, :text
    change_column :questions, :content, :text
    change_column :answers, :content, :text
  end

  def down
    change_column :posts, :content, :string
    change_column :questions, :content, :string
    change_column :answers, :content, :string
  end
end
