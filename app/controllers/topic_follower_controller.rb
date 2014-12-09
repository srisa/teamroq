class TopicFollowerController < ApplicationController
	before_filter  :get_user_and_topic_name
  respond_to :html, :xml, :json, :js
  
  def create
    $redis.sadd @topic.followers_key, current_user.id
    $redis.sadd current_user.topics_following_key, @topic.id
    @followers_count = $redis.scard @topic.followers_key
    render 'topics/follow'
  end

  def destroy
    $redis.srem @topic.followers_key, current_user.id
    $redis.srem current_user.topics_following_key, @topic.id
    @followers_count = $redis.scard @topic.followers_key
    render 'topics/follow'
  end

  private

  def get_user_and_topic_name
  	@user = current_user
    @name = params[:name]
    @topic = ActsAsTaggableOn::Tag.where(name: params[:name]).first	
  end
end
