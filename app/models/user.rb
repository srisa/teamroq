class User < ActiveRecord::Base
  include UsersHelper
  include PgSearch
  extend FriendlyId
  pg_search_scope :whose_name_starts_with, :against => :slug,:using => {
                    :tsearch => {:prefix => true}
                  }
  pg_search_scope :search_name, :against => :name, :using => [:tsearch, :trigram, :dmetaphone]
  
  rolify

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_presence_of :email, :message => "can't be blank"
  validates_presence_of :name, :message => "can't be blank"
  
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :questions
  has_many :answers
  has_many :posts, :as => :postable
  has_many :comments
  has_many :activities
  has_many :documents
  has_many :group_roles
  has_many :groups, :through => :group_roles
  has_many :project_roles
  has_many :projects, :through => :project_roles
  has_many :points  
  has_many :todos
  has_many :badges , :through => :levels 
  has_many :levels  
  has_many :device_tokens
  has_attached_file :profile_picture, :styles => { :medium => "150x150#", :small => "50x50#",:little =>"32x32#" }, 
  :default_url => "/images/:style/missing.png"
  validates_attachment :profile_picture, content_type: { content_type: /\Aimage\/.*\Z/ }
  has_many :todo_lists,:through => :projects
  
  self.per_page = 5

  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end

  def notification_pointer
    "/messages/#{self.id}/ncount"
  end

  def feed_key
    "users:#{self.id}:feed"
  end

  def notification_key
    "users:#{self.id}:notification"
  end

  def followers_key
    "users:#{self.id}:followers"
  end

  def following_key
    "users:#{self.id}:following"
  end

  def todos_following_key
    "users:#{self.id}:todos"
  end

  def questions_following_key
    "users:#{self.id}:questions"
  end

  def topics_following_key
    "users:#{self.id}:topics"
  end

  def discussions_following_key
    "users:#{self.id}:disucssions"
  end

  def topic_reputation_key name
    "reputation:topic" + name
  end

  def is_admin?
    self.has_role? :admin
  end

  def add_to_feed activity_id
    $redis.zadd feed_key, Time.now.to_i, activity_id
  end

  def add_to_notification activity_id 
    $redis.zadd notification_key, Time.now.to_i, activity_id
  end

  def feed
    $redis.zrevrange(feed_key, 0, 100)
  end

  def notifications
    $redis.zrevrange(notification_key, 0, 100)
  end

  def followers
    $redis.smembers following_key
  end

  class << self

    def search(phrase)
      users = User.whose_name_starts_with(phrase)
      users.collect { |c| {"context" => "user", "id" => c["id"], "name" => c["name"], "path" => "/users/#{c["id"]}"} }
    end

  end
end
