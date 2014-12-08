class CommentProcessingJob
  extend JobsHelper
  @queue = :comments
  @log = Logger.new 'log/resque.log'

  ############################################################
  # comments should be notified to all users who have commented 
  # on commentable.
  # Activity that comes here is that of commentable
  ###########################################################
  def self.perform activity_id, comment_id
    @comment = Comment.find(comment_id)
  	@commentable = @comment.commentable
  	owner = @commentable.user
    notification_count_pointer = "/messages/" + owner.id.to_s + "/ncount"
    @activity = Activity.find(activity_id)
    @activity_user_id = @activity.user_id
  	# If comments are for questions then update the question owner
  	if @commentable.is_a? Question
      unless owner.id == @activity_user_id
        owner.add_to_notification activity_id
        owner.save
        increase_notification_pointer(notification_count_pointer)
      end
      @users = User.find(@commentable.followers)
      @users.each do |user| 
        user.add_to_feed(activity_id)
        user.save
      end
      #even if creator of the question does not follow the question, he should be notified
      unless @commentable.followers.include? owner.id
        owner.add_to_notification activity_id
        owner.save
      end
      
      award_teamplayer(@activity_user_id)
      award_proactive_comments(@activity_user_id,@commentable)
    elsif @commentable.is_a? Answer
      owner.add_to_feed activity_id
      unless owner.id == @activity_user_id
        owner.add_to_notification activity_id
        increase_notification_pointer(notification_count_pointer)
      end
      owner.save
      award_teamplayer(@activity_user_id)
      award_proactive_comments(@activity_user_id,@commentable)
    elsif @commentable.is_a? Post
      owner.add_to_feed activity_id
      unless owner.id == @activity_user_id
        owner.add_to_notification activity_id
        increase_notification_pointer(notification_count_pointer)
      end
      owner.save
      award_teamplayer(@activity_user_id)
      award_proactive_comments(@activity_user_id,@commentable)
    elsif @commentable.is_a? Discussion
      discussion_notify_util @commentable,activity_id,@activity_user_id
      award_teamplayer(@activity_user_id)
      award_proactive_comments(@activity_user_id,@commentable)
    elsif @commentable.is_a? Todo
      todo_notify_util @commentable,activity_id,@activity_user_id
      award_teamplayer(@activity_user_id)
      award_proactive_comments(@activity_user_id,@commentable)
    end 
    
  end
   
end