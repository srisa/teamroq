class FollowersController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :get_user
  def create
    $redis.sadd @user.followers_key, current_user.id
    $redis.sadd current_user.followers_key, @user.id
    render 'users/userfollow' 
  end

  def destroy
    $redis.srem @user.followers_key, current_user.id
    $redis.srem current_user.followers_key, @user.id
    render 'users/userfollow' 
  end

  private
    def get_user
      @user = User.find(params[:id])
    end
end
