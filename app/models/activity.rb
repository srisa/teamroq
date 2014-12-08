class Activity < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::SanitizeHelper
  belongs_to :user
  belongs_to :actable, :polymorphic => true
  belongs_to :trackable, :polymorphic => true
  belongs_to :affected, :polymorphic => true
  #attr_accessible :action, :trackable, :affected, :path,:user,:updated_at
  
  delegate :name , :to => :user, :prefix => :true

  scope :today, -> {where("updated_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)}

  scope :latest_first, -> {order("updated_at desc")}

  scope :this_week, -> {where("updated_at BETWEEN ? AND ?", 
    Time.zone.now.beginning_of_week, Time.zone.now.beginning_of_day)}

  scope :before_this_week, -> {where("updated_at < ? ", 
    Time.zone.now.beginning_of_week)}


  def updated_at_words
    time_ago_in_words(self.updated_at)
  end

  def affected_name
    affected = self.affected
    affected_class = affected.class.name.downcase
    logger.debug "affected_class is #{affected_class} and activity id is #{self.id}"
    if affected_class == 'question' || affected_class == 'post' || affected_class == 'discussion'
      affected.title
    elsif affected_class == 'answer'
      strip_tags(affected.content.truncate(TRIM_LENGTH_NOTIFICATION, separator: ' '))
    else
      unless affected.nil?
        affected.name
      end
    end
  end

  def trackable_name
    trackable = self.trackable
    trackable_class = trackable.class.name.downcase
    if trackable_class == 'question' || trackable_class == 'discussion'
      trackable.title
    elsif trackable_class == 'answer' || trackable_class == 'comment' || trackable_class == 'post'
      strip_tags(trackable.content.truncate(TRIM_LENGTH_NOTIFICATION, separator: ' '))
    else
      unless trackable.nil?
        trackable.name
      end
    end
  end

  def attributes
    super.merge({"updated_at_words" => self.updated_at_words})
  end
end
