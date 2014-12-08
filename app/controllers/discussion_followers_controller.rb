class DiscussionFollowersController < ApplicationController
  before_filter  :get_user_and_project
  respond_to :html, :xml, :json, :js
  
  def create
  	unless @discussion.followers.include? current_user.id
      @discussion.followers.push current_user.id
      @discussion.followers_will_change!
    end
    @discussion.save
    @followers_count = @discussion.followers.length
    render 'discussions/follow'
  end

  def destroy
    if @discussion.followers.include? current_user.id
      @discussion.followers.delete current_user.id
      @discussion.followers_will_change!
    end
    @discussion.save
    @followers_count = @discussion.followers.length
    render 'discussions/follow'
  end

  def add_followers
  	user_list = params[:followers_list]
  	user_arr = user_list.split(',')
    user_arr.each do |u|
      user = User.find(u.strip)
      unless user.nil?
        unless @discussion.followers.include? current_user.id
          @discussion.followers.push current_user.id
        end
      end
    end
    @discussion.followers_will_change!
    @discussion.save
    @followers_count = @discussion.followers.length
    redirect_to :back
  end

  private

  	def get_user_and_project
  		@user = current_user
  		@project = Project.find(params[:project_id])
  		@discussion = @project.discussions.find(params[:id])
  	end
end
