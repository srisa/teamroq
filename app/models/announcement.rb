class Announcement < ActiveRecord::Base
  #attr_accessible :announcable_id, :announcable_type, :content
  belongs_to :announcable, :polymorphic => true
  validates_presence_of :content
  validates_presence_of :announcable
end
