class TodoFollowersController < ApplicationController
  include TodosHelper
  respond_to :html, :xml, :json, :js
  before_filter :get_user

  # PATCH /todo_lists/1/todos/follow
  def create
    $redis.sadd @todo.followers_key, current_user.id
    $redis.sadd current_user.todos_following_key, @todo.id
    @followers_count = $redis.scard @todo.followers_key
    render 'todos/follow'
  end


  # PATCH /todo_lists/1/todos/destroy
  def destroy
    $redis.srem @todo.followers_key, current_user.id
    $redis.srem current_user.todos_following_key, @todo.id
    @followers_count = $redis.scard @todo.followers_key
    render 'todos/follow' 
  end

  # PATCH /todo_lists/1/todos/add_followers
  def add_followers
    user_list = params[:followers_list]
    user_arr = user_list.split(',')
    user_arr.each do |u|
      user = User.find(u.strip)
      unless user.nil?
        unless $redis.sismember @todo.followers_key, current_user.id
          $redis.sadd @todo.followers_key, current_user.id
          $redis.sadd current_user.todos_following_key, @todo.id
        end
      end
    end
    @followers_count = $redis.scard @todo.followers_key
    redirect_to :back
  end

  private

    def get_user
  		@user = current_user
      @todo_list = TodoList.find(params[:todo_list_id])
  		@todo = @todo_list.todos.find(params[:id])
  	end
end
