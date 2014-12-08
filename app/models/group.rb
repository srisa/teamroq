class Group < ActiveRecord::Base
  include PgSearch
  extend FriendlyId
  pg_search_scope :search_name, :against => :name, :using => [:tsearch, :trigram]
  
  resourcify # groups can have users with roles
  # attr_accessible :description, :name
  friendly_id :name, use: :slugged
  validates_presence_of :name

  has_many :group_roles
  has_many :users, :through => :group_roles
  has_many :posts , :as => :postable
  has_many :documents , :as => :attachable
  has_many :actable, :as => :actable
  has_many :announcements, :as => :announcable

  def find_users_by_name_like search_string
    search_string = '%'+search_string.downcase+'%'
    self.users.where("lower(users.name) like ?", search_string)
  end

  def self.search(phrase)
    groups = Group.search_name(phrase).limit(3)
    groups.collect { |c| {"context" => "group", "id" => c["id"], "name" => c["name"], "path" => "/groups/#{c["id"]}"} }
  end

end
