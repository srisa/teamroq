class UsersController < ApplicationController
  respond_to :html, :xml, :json, :js
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => 10)
    logger.debug "page is #{params[:page]}"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @badges = @user.get_badges_no_duplicate_type
    @points =  @user.get_total_points
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  # # POST /users
  # # POST /users.json
  # def create
  #   @user = User.new(user_params)
  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render json: @user, status: :created, location: @user }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /users/1
  # PUT /users/1.json
  def update
    logger.debug "In users controller update method"
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.id != current_user.id
        raise ActionController::RoutingError.new('Not Allowed')
      elsif @user.update_attributes(user_params)
        @points =  @user.get_total_points
        format.html { redirect_to @user, notice: 'Todo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /tasks
  def tasks
    logger.debug "in UsersController tasks method"
    @tasks = current_user.todos.by_open.order_by_target_date.includes(:todo_list).paginate(page: params[:page], per_page: 20)
    @user = current_user
  end

  # GET /tasks/created
  def created_open_tasks
    user_id = current_user.id
    ids = Todo.by_open.pluck(:id)
    versions = PaperTrail::Version.where(item_id:ids,whodunnit:user_id.to_s,item_type:'Todo',event:'created').paginate(page: params[:page], per_page: 10)
    @todos = Array.new
    versions.each do|v|
      todo = Todo.find(v.item_id)
      @todos.push(todo)
    end
  end

  # GET /tasks/created/closed
  def created_closed_tasks
    user_id = current_user.id
    ids = Todo.by_closed.pluck(:id)
    versions = PaperTrail::Version.where(item_id:ids,whodunnit:user_id.to_s,item_type:'Todo',event:'created').paginate(page: params[:page], per_page: 10)
    @todos = Array.new
    versions.each do|v|
      todo = Todo.find(v.item_id)
      @todos.push(todo)
    end
  end

  # GET /documents
  def documents
    @documents = current_user.documents.paginate(page: params[:page],per_page: 10)
  end

  # GET /tasks/closed
  def closed
    @tasks = current_user.todos.includes(:todo_list).by_closed.paginate(page: params[:page], per_page: 10)
    @user = current_user
  end

  # GET /myquestions
  def myquestions
    if params[:filter] == 'created'
      @questions = current_user.questions.paginate(page: params[:page], per_page: 10)
      @test = 0
    elsif params[:filter] == 'following'
      @test = 1
      @questions = Question.where("? = ANY(followers)", current_user.id).paginate(page: params[:page], per_page: 10)
    else
      @questions = current_user.questions.paginate(page: params[:page], per_page: 10)
    end
    respond_with(@questions)
  end

  # GET /mytopics
  def mytopics
    if params[:filter] == 'following'
      @tags = ActsAsTaggableOn::Tag.where("? = ANY(followers)", current_user.id)
    else
      @tags = Question.topic_counts
    end
    render 'questions/index'
  end

private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation,:profile_picture,:desk,:designation,:skill,:detail,:time_zone)
  end
end


