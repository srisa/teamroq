class Post < ActiveRecord::Base
  # attr_accessible :content,:documents_attributes,:postable_type, :topic_list,:title
  validates_presence_of :content , message: "Content cant be blank"
  validates_presence_of :user
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents , :as => :attachable
  has_many  :favorites, :as => :favorable
  has_one :activity, :as => :trackable, :dependent => :destroy
  belongs_to :user
  belongs_to :postable, :polymorphic => true
  
  acts_as_ordered_taggable_on :topics
 
  delegate :name, :to => :user , :prefix => true
  accepts_nested_attributes_for :documents
  
  scope :recent , -> {order("updated_at DESC")}
  scope :created_by , ->(user)  { where(:user_id => user)}
  scope :updated_today, -> {where("updated_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)}
end
