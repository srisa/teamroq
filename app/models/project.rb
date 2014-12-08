class Project < ActiveRecord::Base
  include PgSearch
  resourcify # Projects can have users with roles
  extend FriendlyId

  pg_search_scope :search_name, :against => :name, :using => [:tsearch, :trigram]
  
  validates_presence_of :name

  friendly_id :name, use: [:slugged,:finders]
  
  has_many :project_roles 
  has_many :users, :through => :project_roles
  has_many :todo_lists
  has_many :todos, :through => :todo_lists
  has_many :discussions , :as => :discussable
  has_many :documents , :as => :attachable
  has_many :activities , :as => :actable
 
  accepts_nested_attributes_for :project_roles
  
  def find_users_by_name_like search_string
    search_string = '%'+search_string.downcase+'%'
    self.users.where("lower(users.name) like ?", search_string)
  end

  def self.search(phrase)
    projects = Project.search_name(phrase).limit(3)
    projects.collect { |c| {"context" => "project", "id" => c["id"], "name" => c["name"], "path" => "/projects/#{c["id"]}"} }
  end
end
