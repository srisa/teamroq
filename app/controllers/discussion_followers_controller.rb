class DiscussionFollowersController < ApplicationController
  before_filter  :get_user_and_project
  respond_to :html, :xml, :json, :js
  
  def create
  	$redis.sadd @discussion.followers_key, current_user.id
    $redis.sadd current_user.discussions_following_key, @discussion.id
    @followers_count = $redis.scard @discussion.followers_key
    render 'discussions/follow'
  end

  def destroy
    $redis.srem @discussion.followers_key, current_user.id
    $redis.srem current_user.discussions_following_key, @discussion.id
    @followers_count = $redis.scard @discussion.followers_key
    render 'discussions/follow'
  end

  def add_followers
  	user_list = params[:followers_list]
  	user_arr = user_list.split(',')
    user_arr.each do |u|
      user = User.find(u.strip)
      unless user.nil?
        unless $redis.sismember @discussion.followers_key, current_user.id
          $redis.sadd @discussion.followers_key, current_user.id
          $redis.sadd current_user.discussions_following_key, @discussion.id
        end
      end
    end
    @followers_count = $redis.scard @discussion.followers_key
    redirect_to :back
  end

  private

  	def get_user_and_project
  		@user = current_user
  		@project = Project.find(params[:project_id])
  		@discussion = @project.discussions.find(params[:id])
  	end
end
