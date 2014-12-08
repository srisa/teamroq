class TodoFollowersController < ApplicationController
  include TodosHelper
  respond_to :html, :xml, :json, :js
  before_filter :get_user

  # PATCH /todo_lists/1/todos/follow
  def create
    unless @todo.followers.include? current_user.id
      @todo.followers.push current_user.id
      @todo.followers_will_change!    
    end	
    @todo.save
    @followers_count = @todo.followers.length
    render 'todos/follow'
  end


  # PATCH /todo_lists/1/todos/destroy
  def destroy
    if @todo.followers.include? current_user.id
      @todo.followers.delete current_user.id
      @todo.followers_will_change! 
    end 
    @todo.save
    @followers_count = @todo.followers.length
    render 'todos/follow' 
  end

  # PATCH /todo_lists/1/todos/add_followers
  def add_followers
    user_list = params[:followers_list]
    user_arr = user_list.split(',')
    user_arr.each do |u|
      user = User.find(u.strip)
      unless user.nil?
        unless @todo.followers.include? user.id
          @todo.followers.push user.id
        end
      end
    end
    @todo.followers_will_change!
    @todo.save
    @followers_count = @todo.followers.length
    redirect_to :back
  end

  private

    def get_user
  		@user = current_user
      @todo_list = TodoList.find(params[:todo_list_id])
  		@todo = @todo_list.todos.find(params[:id])
  	end
end
