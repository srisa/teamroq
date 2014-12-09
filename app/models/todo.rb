class Todo < ActiveRecord::Base
  extend FriendlyId
  # attr_accessible :name,:details,:closed_on, :reopened_on, :state,:target_date, :user_id, :slug, :todo_list_id
  friendly_id :name, use: :slugged
  
  validates_presence_of :name
  validates_presence_of :details
  validates_presence_of :target_date
  validates_presence_of :user_id
  validates_presence_of :todo_list_id

  belongs_to :todo_list
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :activities, :as => :trackable, :dependent => :destroy
  has_many :references, :as => :referencable

  delegate :project, :to => :todo_list
  
  has_paper_trail :ignore => [:name,:details,:slug]

  scope :by_closed, ->{where(:state => 'closed')}
  scope :by_open, ->{where(:state => 'open')}
  scope :by_reopened, ->{where(:state => 'reopen')}
  scope :not_closed, ->{where("todos.state <> ?","closed")}
  scope :pending_today , ->{where(:target_date => Time.zone.now.to_date) }
  scope :pending_this_week, ->{
              where("todos.target_date <= :to AND todos.target_date > :from", :from => Time.zone.now.to_date, :to => Time.zone.now.to_date + 7.days)
        }
  scope :delayed_tasks, ->{
    where("todos.target_date < :from", :from => Time.zone.now.to_date)
  }
  scope :all_delayed, ->{
    where("todos.target_date < todos.closed_on OR (todos.target_date < :from AND todos.state <> :state)", :from => Time.zone.now.to_date, :state => 'closed')
  }
  scope :closed_delayed,->{ where("todos.target_date < todos.closed_on AND todos.state = ?", 'closed')}

  scope :order_by_target_date, ->{order("todos.target_date asc")}
  scope :updated_today, -> {where("todos.created_at < ? AND todos.updated_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_day,Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)}
  scope :closed_recently, -> {where("todos.state LIKE ? AND todos.closed_on  BETWEEN ? AND ?", 'closed',
    2.day.ago.in_time_zone.beginning_of_day, Time.zone.now)}
  scope :created_today, -> {where("todos.created_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)}
  
  
  state_machine :initial => :open do

    after_transition  :on => :close do |todo, transition|
      todo.closed_on = DateTime.now.in_time_zone
    end

    event :close do 
      transition [:open] => :closed
    end

    event :reopen do
      transition :closed => :open
    end
  end

  def followers_key
    "todos:#{self.id}:followers"
  end

  def followers
    $redis.smembers followers_key
  end
  
  def add_watchers_to_todo user_list
    user_arr = user_list.split(',')
    user_arr.each do |u|
      user = User.find_by_name(u.strip)
      unless user.nil?
        unless self.followers.include? user.id
          $redis.sadd followers_key, user.id
        end
      end
    end
  end 


  def add_owner owner_id
    $redis.sadd followers_key, owner_id
  end
 
end
