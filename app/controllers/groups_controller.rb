class GroupsController < ApplicationController
  include GroupsHelper
   before_filter :get_user
   
  # GET /groups
  # GET /groups.json
  def index
    @groups = @user.groups.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @postable = @group = Group.find(params[:id])
    @posts = @group.posts.includes(:user)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    user_list = params[:user_list]
    respond_to do |format|
      if @group.save
        unless @group.id.nil?
          add_users_to_group(user_list,@group.id)
        end
        current_user.add_role :manager, @group
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    if (current_user.has_role? :manager, @group) || (current_user.has_role? :admin)
      @group.destroy
    else
      flash[:notice] = "You are not authorized to delete this Project."
    end
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  # POST /groups/1/add_users
  def add_users
    user_list = params[:user_list]
    group_id = params[:group_id]
    add_users_to_group(user_list,group_id)
    redirect_to :back
  end
  
  # GET /groups/1/users
  def users
    @group = Group.find(params[:id])
    @users = @group.users.paginate(:page => params[:page], :per_page => 9)
  end

  #GET /groups/1/documents
  def documents
    @attachable = @group = Group.find(params[:id])
    if params[:filter] == 'today'
      @documents = @group.documents.updated_today.paginate(page: params[:page], per_page: 10)
    elsif params[:filter] == 'popular'
      @documents = @group.documents.paginate(page: params[:page], per_page: 10)
    elsif params[:filter] == 'byme'
      @documents = @group.documents.created_by(current_user.id).paginate(page: params[:page], per_page: 10)
    else
      @documents = @group.documents.paginate(page: params[:page], per_page: 10)
    end   
    @document = Document.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

 private
  def group_params
    params.require(:group).permit(:name)
  end
  
  def get_user
    @user = current_user
  end
end
