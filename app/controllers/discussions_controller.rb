class DiscussionsController < ApplicationController
  include DiscussionsHelper
  before_filter :get_user_and_load_project

  # GET /projects/1/discussions
  # GET /projects/1/discussions.json
  def index
    @discussions = @project.discussions.paginate(page: params[:page], per_page: 10)
    if params[:filter] == 'latest'
      @discussions = @project.discussions.updated_today.paginate(page: params[:page], per_page: 10)
    elsif params[:filter] == 'popular'
      @discussions = @project.discussions.recent.paginate(page: params[:page], per_page: 10)
    elsif params[:filter] == 'followed'
      @discussions = @project.discussions.where("? = ANY(followers)", current_user.id).paginate(page: params[:page], per_page: 10)
    elsif params[:filter] == 'created'  
      @discussions = @project.discussions.created_by(current_user.id).paginate(page: params[:page], per_page: 10)
    else
      @discussions = @project.discussions.recent.paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discussions }
    end
  end

  # GET /projects/1/discussions/1
  # GET /projects/1/discussions/1.json
  def show
    @discussion = @project.discussions.find(params[:id])
    @commentable = @discussion
    @comment = Comment.new(:commentable_id => @discussion.id, :commentable_type => @discussion.class.name)
    @watchers = User.find(@discussion.followers)
    @followers_count = @watchers.length

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discussion }
    end
  end

  # GET /projects/1/discussions/new
  # GET /projects/1/discussions/new.json
  def new
    @discussion = @project.discussions.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discussion }
    end
  end

  # GET /projects/1/discussions/1/edit
  def edit
    @discussion = @project.discussions.find(params[:id])
  end

  # POST /projects/1/discussions
  # POST /projects/1/discussions.json
  def create
    @discussion = @project.discussions.build(discussion_params)
    user_list = params[:followers_list]
    logger.debug "user_list is #{user_list}"
    @discussion.user = current_user
    unless user_list.nil?
      @discussion.add_bulk_followers_for_discussion(user_list)
    end
    respond_to do |format|
      if @discussion.save
        track_discussion_activity_create @discussion
        format.html { redirect_to [@project, @discussion], notice: 'Discussion was successfully created.' }
        format.json { render json: @discussion, status: :created, location: @discussion }
      else
        format.html { render action: "new" }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1/discussions/1
  # PUT /projects/1/discussions/1.json
  def update
    @discussion = @project.discussions.find(params[:id])
    respond_to do |format|
      if @discussion.update_attributes(discussion_params)
        format.html { redirect_to [@project, @discussion], notice: 'Discussion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1/discussions/1
  # DELETE /projects/1/discussions/1.json
  def destroy
    @discussion = @project.discussions.find(params[:id])
    @discussion.destroy
    respond_to do |format|
      format.html { redirect_to project_discussions_url(@project) }
      format.json { head :no_content }
    end
  end

  # GET /projects/1/discussions/searchuser
  def searchuser
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

    def discussion_params
      params.require(:discussion).permit(:title,:content)
    end

    def get_user_and_load_project
      @user = current_user
      @project = Project.find(params[:project_id])
    end

end
