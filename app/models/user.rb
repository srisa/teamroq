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
  validates_presence_of :password, :message => "can't be blank"

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
  has_many :favorites
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

  def is_admin?
    self.has_role? :admin
  end

  def add_to_feed activity_id
    if self.feed.include? activity_id
      self.feed.delete activity_id
    end
    self.feed.push activity_id
    self.feed_will_change!
  end

  def add_to_notification activity_id
    if self.notifications.include? activity_id
      self.notifications.delete activity_id
    end
    self.notifications.push activity_id
    self.notifications_will_change!
  end

  class << self

    def search(phrase)
      users = User.whose_name_starts_with(phrase)
      users.collect { |c| {"context" => "user", "id" => c["id"], "name" => c["name"], "path" => "/users/#{c["id"]}"} }
    end

  end


end
