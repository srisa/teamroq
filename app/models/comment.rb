class Comment < ActiveRecord::Base
  #attr_accessible :content, :user_id, :commentable_id, :commentable_type
  belongs_to :user
  has_many :favorites, :as => :favorable
  has_many :activities, :as => :trackable, :dependent => :destroy
  belongs_to :commentable, :polymorphic => true, :touch => true
  
  delegate :name, :to => :user, :prefix => true

  validates_presence_of :content
  validates_presence_of :user
  validates_presence_of :commentable

  scope :recent , -> {order("created_at ASC")}
end
