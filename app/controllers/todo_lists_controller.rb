class TodoListsController < ApplicationController
  before_filter  :get_user_and_project
  # GET /todo_lists
  # GET /todo_lists.json
  def index
    @todo_lists = @project.todo_lists

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @todo_lists }
    end
  end

  # GET /todo_lists/1
  # GET /todo_lists/1.json
  def show
    @todo_list = @project.todo_lists.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @todo_list }
    end
  end

  # GET /todo_lists/new
  # GET /todo_lists/new.json
  def new
    @todo_list = @project.todo_lists.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @todo_list }
    end
  end

  # GET /todo_lists/1/edit
  def edit
    @todo_list = @project.todo_lists.find(params[:id])
  end

  # POST /todo_lists
  # POST /todo_lists.json
  def create
    @todo_list = @project.todo_lists.build(todo_list_params)
    logger.debug "todolist is #{@todo_list.attributes.inspect}"
    @project = @todo_list.project
    respond_to do |format|
      if @todo_list.save
        track_todo_list_activity_create @todo_list
        format.html { redirect_to @project, notice: 'Todo list was successfully created.' }
        format.json { render json: @todo_list, status: :created, location: @todo_list }
      else
        format.html { render action: "new" }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /todo_lists/1
  # PUT /todo_lists/1.json
  def update
    @todo_list = @project.todo_lists.find(params[:id])

    respond_to do |format|
      if @todo_list.update_attributes(todo_list_params)
        track_todo_list_activity @todo_list
        format.html { redirect_to [@project,@todo_list], notice: 'Todo list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_lists/1
  # DELETE /todo_lists/1.json
  def destroy
    @todo_list = @project.todo_lists.find(params[:id])
    @todo_list.destroy

    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :no_content }
    end
  end

  # GET /projects/1/todo_lists/1/closed
  def closed
    @todo_list = @project.todo_lists.find(params[:id])
    @closed_todos = @todo_list.todos.by_closed
  end

  private
  
    def todo_list_params
      params.require(:todo_list).permit(:name)
    end

    def get_user_and_project
      @user = current_user
      @project = @user.projects.find(params[:project_id])
    end
end
