class ProjectsController < ApplicationController
  include ProjectsHelper
  respond_to :html, :xml, :json, :js
  before_filter  :get_user
  
  # GET /projects
  # GET /projects.json
  def index
    @projects = @user.projects.paginate(:page => params[:page], :per_page=> 8)
    @percentages = Hash.new
    @projects.each do |project|
      all = project.todos.count
      open = project.todos.by_open.count
      if all == 0
        @percentages[project.id] = 0
      else
        openP = open.to_f/all
        completion_percentage = (1-openP)*100
        @percentages[project.id] = completion_percentage.round
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = @user.projects.find(params[:id])
    @members = @project.users
    @todolists = @project.todo_lists
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  
  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    # @project.users.push(@user)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = @user.projects.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    user_list = params[:user_list]
    respond_to do |format|
      if @project.save
        unless @project.id.nil?
          @user.projects.push @project
          add_users_to_project(user_list,@project)
        end
        current_user.add_role :manager, @project
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = @user.projects.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    if (current_user.has_role? :manager, @project) || (current_user.has_role? :admin)
      @project.destroy
    else
      flash[:notice] = "You are not authorized to delete this Project."
    end
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.json { head :no_content }
    end
  end

  # POST /projects/add_users
  def add_users
    user_list = params[:user_list]
    @project = @user.projects.find(params[:project_id])
    add_users_to_project(user_list,@project)
    redirect_to :back
  end

  # GET /projects/1/documents
  def documents
    @attachable = @project = @user.projects.find(params[:id])
    if params[:filter] == 'today'
      @documents = @project.documents.updated_today.paginate(page: params[:page], per_page: 10)
    elsif params[:filter] == 'popular'
      @documents = @project.documents.paginate(page: params[:page], per_page: 10)
    elsif params[:filter] == 'byme'
      @documents = @project.documents.created_by(current_user.id).paginate(page: params[:page], per_page: 10)
    else
      @documents = @project.documents.paginate(page: params[:page], per_page: 10)
    end
    @document = Document.new
    @document.document_versions.build
    respond_with(@project)
  end

  # GET /projects/1/users
  def users
    @project = @user.projects.find(params[:id])
    @users = @project.users.paginate(page: params[:page], per_page: 10)
  end

  # GET /projects/1/standup
  def standup
    @project = @user.projects.find(params[:id])
    @open_todos = @project.todos.includes(:todo_list, :user).by_open.group_by {|todo| todo.user}
    @closed_today = @project.todos.includes(:todo_list, :user).closed_recently.group_by{|todo| todo.user}
  end

  private
  
    def project_params
      params.require(:project).permit(:name,:details)
    end
    def get_user
      @user = current_user
    end

end
