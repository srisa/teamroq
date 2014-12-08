class TopicFollowerController < ApplicationController
	before_filter  :get_user_and_topic_name
  respond_to :html, :xml, :json, :js
  
  def create
    unless @topic.followers.include? current_user.id
      @topic.followers.push current_user.id
      @topic.followers_will_change! 
    end 
    @topic.save
    @followers_count = @topic.followers.count
    render 'topics/follow'
  end

  def destroy
    if @topic.followers.include? current_user.id
      @topic.followers.delete current_user.id
      @topic.followers_will_change! 
    end 
    @topic.save
    @followers_count = @topic.followers.count
    render 'topics/follow'
  end

  private

  def get_user_and_topic_name
  	@user = current_user
    @name = params[:name]
    @topic = ActsAsTaggableOn::Tag.where(name: params[:name]).first	
  end
end
