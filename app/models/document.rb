class Document < ActiveRecord::Base
  include PgSearch
  belongs_to :user

  belongs_to :attachable , :polymorphic => true
  belongs_to :referencable, :polymorphic => true

  scope :updated_today, -> {where("updated_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)}

  scope :created_by , ->(user)  {where(:user_id => user)}
  
  has_one :activity, :as => :trackable, :dependent => :destroy
  has_many :document_versions, autosave: true, :dependent => :destroy
  accepts_nested_attributes_for :document_versions

  validates_presence_of :name
  
end
