require "reputation_helper"
class CommentsController < ApplicationController
  include ReputationHelper
  respond_to :html, :xml, :json, :js
  before_filter :load_commentable

  # GET /commentable/1/comments
  def index
    @comments = @commentable.comments.reverse
  end

  # GET /commentable/1/comments/new
  def new
    @comment = @commentable.comments.new
  end

  # POST /commentable/1/comments
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      track_comment_activity_create(@comment)
      flash[:notice] = "Successfully saved comment."
      # points_for_commenting current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js #create.js
        format.json {render @comment }
      end
    else
      render 'new'
    end
  end

  # POST /commentable/1/activity_comment
  def activity_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @activity = Activity.find(params[:activity_id])
    if @comment.save
      track_comment_activity_create(@comment, 'create')
      respond_to do |format|
        format.html { redirect_to :back }
        format.js #activity_comment.js
        format.json {render @comment }
      end
    end
  end
 
  # GET /commentable/1/activitycomments/:activity_id
  def activitycomments
    activity_id = params[:activity_id]
    @activity = Activity.find(activity_id)
    respond_with(@commentable)
  end

  # GET JS /comments/showcomment
  def showcomment
    logger.debug "commentable : #{@commentable.attributes.inspect}"
    @comments = @commentable.comments
    name_id = @commentable.class.name.downcase+@commentable.id.to_s
    @comment_section_id = 'comment-list-'+name_id
    @show_comment_link_id = 'show-comment-btn-'+name_id
    respond_with(@comments)
  end

private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_commentable
    klass = [Question, Answer, Todo,Discussion, Post].detect { |c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

end
