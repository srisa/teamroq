class ProjectRolesController < ApplicationController
   before_filter :get_user_and_project, :only => [:new,:create]
   before_filter :get_user_and_model, :except => [:new,:create]
  # GET /project_roles
  # GET /project_roles.json
  def index
    @project_roles = @role_model.project_roles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_roles }
    end
  end



  # GET /project_roles/new
  # GET /project_roles/new.json
  def new
    @project_role = @project.project_roles.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_role }
    end
  end


  # POST /project_roles
  # POST /project_roles.json
  def create
    @project_role = @project.project_roles.build(params[:project_role])
    @user = User.find_by_email(params[:user][:email])
    unless @user
      errors.add(:base, "Invalid email address")
      redirect_to @project_role
    end
    @project_role.user = @user

    respond_to do |format|
      if @project_role.save
        format.html { redirect_to @project_role, notice: 'Project role was successfully created.' }
        format.json { render json: @project_role, status: :created, location: @project_role }
      else
        format.html { render action: "new" }
        format.json { render json: @project_role.errors, status: :unprocessable_entity }
      end
    end
  end

 
  # DELETE /project_roles/1
  # DELETE /project_roles/1.json
  def destroy
    @project_role = @role_model.project_roles.find(params[:id])
    @project_role.destroy

    respond_to do |format|
      format.html { redirect_to project_roles_url }
      format.json { head :no_content }
    end
  end

   private

    def get_user_and_model
      klass = [User,Project].detect { |c| params["#{c.name.underscore}_id"]}
      @role_model = klass.find(params["#{klass.name.underscore}_id"])
    end

    def get_user_and_project
      @project = @current_user.projects.find(params[:project_id])  
    end
end
