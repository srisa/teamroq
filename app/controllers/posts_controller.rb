class PostsController < ApplicationController
  include PostsHelper
  before_filter  :get_user_and_load_postable
  
  def index
    @posts = @postable.posts
    @post = Post.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = @postable.posts.find(params[:id])
    @commentable = @post
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = @postable.posts.new
    @post.documents.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = @postable.posts.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = @postable.posts.build(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save
        track_activity_create @post
        format.html { redirect_to :back, notice: 'Post was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = @postable.posts.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(post_params)
        track_activity @post
        format.html { redirect_to [@postable,@post], notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = @postable.posts.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end
    
    def get_user_and_load_postable
      @user = current_user
      klass = [User, Project, Group].detect { |c| params["#{c.name.underscore}_id"]}
      logger.debug "Klass is : #{klass}"
      @postable = klass.find(params["#{klass.name.underscore}_id"])
    end
end
