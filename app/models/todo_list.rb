class TodoList < ActiveRecord::Base
  extend FriendlyId
  # attr_accessible :name, :slug
  
  validates_presence_of :name, :message => "can't be blank"

  friendly_id :name, use: :slugged

  belongs_to :project
  has_many :todos
  
  scope :updated_today, -> {where("todo_lists.created_at < ? AND todo_lists.updated_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_day,Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)}
  scope :created_today, -> {where("todo_lists.created_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)}
end
