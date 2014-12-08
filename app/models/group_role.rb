class GroupRole < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  # attr_accessible :user_id, :project_id
  # attr_accessible :title, :body
end
