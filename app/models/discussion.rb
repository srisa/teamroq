class Discussion < ActiveRecord::Base
  include PgSearch
  #attr_accessible :content, :title, :discussable_type
  
  validates_presence_of :content , message: "Content cant be blank"
  validates_presence_of :title , message: "Title cant be blank"
  
  has_one :activity, :as => :trackable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  belongs_to :user
  belongs_to :discussable, :polymorphic => true
  
  delegate :name, :to => :user , :prefix => true

  scope :recent , -> {order("updated_at DESC")}
  scope :created_by , ->(user) { where(:user_id => user)}
  scope :updated_today, -> {where("updated_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)}

  def add_bulk_followers_for_discussion user_list
    user_arr = user_list.split(',')
    user_arr.each do |u|
      user = User.where(name: u.strip)[0]
      unless user.nil?
        unless self.followers.include? user.id
          self.followers.push user.id
        end
      end
    end
  end

end
