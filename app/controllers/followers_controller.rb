class FollowersController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :get_user
  def create
    unless @user.followers.include? current_user.id
      @user.followers.push current_user.id
      @user.followers_will_change!
    end
    @user.save
    render 'users/userfollow' 
  end

  def destroy
    if @user.followers.include? current_user.id
      @user.followers.delete current_user.id
      @user.followers_will_change!
    end
    @user.save
    render 'users/userfollow' 
  end

  private
    def get_user
      @session_user = current_user
      @user = User.find(params[:id])
    end
end
