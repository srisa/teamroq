class AddMissingIndexes < ActiveRecord::Migration
   def change
        add_index :taggings, [:tagger_id, :tagger_type]
        add_index :favorites, [:favorable_id, :favorable_type]
        add_index :favorites, :user_id
        add_index :levels, :badge_id
        add_index :levels, :user_id
        add_index :levels, [:badge_id, :user_id]
        add_index :todos, :user_id
        add_index :answers, :question_id
        add_index :answers, :user_id
        add_index :badges, :type_id
        add_index :comments, :user_id
        add_index :comments, [:commentable_id, :commentable_type]
        add_index :points, :type_id
        add_index :points, :user_id
        add_index :questions, :user_id
        add_index :posts, :user_id
        add_index :posts, [:postable_id, :postable_type]
        add_index :documents, :user_id
        add_index :documents, [:attachable_id, :attachable_type]
        add_index :todo_lists, :project_id
        add_index :activities, [:trackable_id, :trackable_type]
        add_index :activities, [:affected_id, :affected_type]
    end

end
