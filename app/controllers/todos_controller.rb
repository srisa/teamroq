class TodosController < ApplicationController
  include TodosHelper
  respond_to :html, :xml, :json, :js
  before_filter :get_user_and_todo_list, :except => [:new,:create]
  
  # GET /todo_lists/1/todos
  # GET /todo_lists/1/todos.json
  def index
    @todos = @todo_list.todos
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @todos }
    end
  end

  # GET /todo_lists/1/todos/1
  # GET /todo_lists/1/todos/1.json
  def show
    @todo = @todo_list.todos.find(params[:id])
    @comments = @todo.comments
    @commentable = @todo
    @project =  @todo.todo_list.project
    @watchers = User.find(@todo.followers)
    @followers_count = @watchers.length
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @todo }
    end
  end

  # GET /todo_lists/1/todos/new
  # GET /todo_lists/1/todos/new.json
  def new
    @todo = Todo.new
    @todo_lists = current_user.todo_lists
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @todo }
    end
  end

  # GET /todo_lists/1/todos/1/edit
  def edit
    @todo = @todo_list.todos.find(params[:id])
    @project = @todo_list.project
    @todo_lists = @project.todo_lists
  end

  # POST /todo_lists/1/todos
  # POST /todo_lists/1/todos.json
  def create
    if !params[:todo_list_id].blank?
      logger.debug "In create TodosController from todolist page"
      @todo_list = TodoList.find(params[:todo_list_id]) 
    else
      logger.debug "In create TodosController coming from main page"
      @todo_list = TodoList.find(params[:todo][:todo_list_id])
    end
    todo_params.except!(:todo_list_id)
    @todo = @todo_list.todos.build(todo_params)
    @todo.paper_trail_event = 'created'
    if @todo.user_id.nil?
      @todo.user_id = current_user.id
    end
    user_list = params[:watchers_list]
    unless  user_list.nil?
      @todo.add_watchers_to_todo(user_list)
    end
    @todo.add_owner(current_user.id)
    respond_to do |format|
      if @todo.save
        track_todo_activity @todo
        format.html { redirect_to [@todo_list,@todo], notice: 'Todo was successfully created.' }
        format.json { render json: @todo, status: :created, location: @todo }
      else
        format.html { render action: "new" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /todo_lists/1/todos/1
  # PUT /todo_lists/1/todos/1.json
  def update
    @todo = Todo.find(params[:id])
    @todo.paper_trail_event = 'updated'
    logger.debug "In update TodosController todo new object #{@todo.attributes.inspect}"
    respond_to do |format|
      if @todo.update_attributes(todo_params)
        track_todo_activity @todo
        #adding logic to add watchers list while creating a task should move to jobs
        user_list = params[:watchers_list]
        unless  user_list.nil?
          add_watchers_to_todo(user_list, @todo.id)
        end
        #adding logic of watchers list ends here
        format.html { redirect_to [@todo.todo_list,@todo], notice: 'Todo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_lists/1/todos/1
  # DELETE /todo_lists/1/todos/1.json
  def destroy
    @todo = @todo_list.todos.find(params[:id])
    if @todo.user.id == current_user.id
      @todo.destroy
      #run hooks to delete links in searches redis
    else
      flash[:notice] ="You are not authorized to delete this task. 
      This task is not assigned to you."
    end

    respond_to do |format|
      format.html { redirect_to '/tasks' }
      format.json { head :no_content }
    end
  end

  # PATCH /todo_lists/1/todos/1
  # PATCH /todo_lists/1/todos/1.json
  def change_date
    @todo = @todo_list.todos.find(params[:id])
    @todo.paper_trail_event = 'change date'
    logger.debug "In change_date TodosController todo new object #{@todo.attributes.inspect}"
    respond_to do |format|
      if @todo.update_attributes(change_date_params)
        track_todo_activity_change_date @todo
        format.html { redirect_to [@todo_list,@todo], notice: 'Target date has been successfully changed' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /todo_lists/1/todos/1
  # PUT /todo_lists/1/todos/1.json
  def change_user
    @todo = @todo_list.todos.find(params[:id])
    @todo.paper_trail_event = 'change user'
    logger.debug " In change_user TodosController todo new object #{@todo.attributes.inspect}"
    respond_to do |format|
      if @todo.update_attributes(change_user_params)
        track_todo_activity_change_user @todo
        format.html { redirect_to [@todo_list,@todo], notice: 'Assigned user has been successfully changed' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /todo_lists/1/todos/1/close
  def close
    @todo = @todo_list.todos.find(params[:id])
    @todo.paper_trail_event = 'closed'
    @todo.closed_on = Time.zone.now
    @todo.close
    track_todo_activity @todo, "close"
    redirect_to :back
  end

  # PATCH /todo_lists/1/todos/1/close
  def reopen
    @todo = @todo_list.todos.find(params[:id])
    @todo.paper_trail_event = 'reopened'
    @todo.closed_on = nil
    @todo.reopen
    track_todo_activity @todo, "reopen"
    redirect_to :back
  end

  # PATCH /todo_lists/1/todos/1/close
  def state_history 
    @todo = @todo_list.todos.find(params[:id])
    @states = @todo.versions.where(:event => ['closed','reopened','created'])
    respond_with (@states)   
  end

  # PATCH /todos/searchuser
  def searchuser
    @project = @todo_list.project
    search_string = params[:name]
    @users = @project.find_users_by_name_like(search_string)
    logger.debug "Searching user from projects and users size #{@users.size}"
    respond_to do |format|
      format.json do
        render :json => @users.to_json(:only => [ :id, :slug ])
      end
    end 
  end

  private

    def todo_params
      params.require(:todo).permit(:name,:details,:target_date, :user_id)
    end

    def change_date_params
      params.require(:todo).permit(:target_date)
    end

    def change_user_params
      params.require(:todo).permit(:user_id)
    end
    
    def get_user_and_todo_list
      @user = current_user
      @todo_list = TodoList.find(params[:todo_list_id])
    end
end
