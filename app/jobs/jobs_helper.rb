module JobsHelper
  @log = Logger.new 'log/resque.log'
	def increase_notification_pointer notification_count_pointer
    $redis.incr(notification_count_pointer)
    hex = Digest::SHA256.hexdigest(notification_count_pointer)[1,12]
    @log.debug "Notification Pointer #{notification_count_pointer} Hex#{hex}"
    notification_count = $redis.get(notification_count_pointer)
    PrivatePub.publish_to("/messages/#{hex}",:message => notification_count )
  end

  def award_good_answer user_id, marks
    @log.debug "award_good_answer #{user_id} #{marks}"
    @type = Type.find_by_name("Good Answer")
    @owner = User.find(user_id)
    @owner.change_points({ points: marks, type: @type.id })
  end

  def award_good_question user_id, marks
    @log.debug "award_good_question #{user_id} #{marks}"
    @type = Type.find_by_name("Good Question")
    @owner = User.find(user_id)
    @owner.change_points({ points: marks, type: @type.id })
  end

  def award_teamplayer user_id
    @log.debug "award_teamplayer #{user_id}"
    @type = Type.find_by_name('Team Player')
    @owner = User.find(user_id)
    @owner.change_points({ points: POINTS_FOR_TEAMPLAYER, type: @type.id })
  end

  def award_proactive_comments user_id,commentable
    if commentable.comments.count==1
      @log.debug "award_proactive_comments to #{user_id} for #{commentable.class.name} #{commentable.id}"
      @type = Type.find_by_name('Proactive')
      @owner = User.find(user_id)
      @owner.change_points({ points: POINTS_FOR_PROACTIVE_COMMENT, type: @type.id })
    end
  end

  def award_proactive_answers user_id,question
    if question.answers.count==1
      @log.debug "award_proactive_answers to #{user_id} for question #{question.id}"
      @type = Type.find_by_name('Proactive')
      @owner = User.find(user_id)
      @owner.change_points({ points: POINTS_FOR_PROACTIVE_ANSWER, type: @type.id })
    end
  end

  def todo_notify_util todo,activity_id,activity_user_id
    @project = todo.project
    @project_users = @project.users
    @log.debug "todo_notify_util and project #{@project.name}"
    @project_users.each do |user|
      @log.debug "feed items creation for user id #{user.id}"
      user.add_to_feed activity_id
    end
    todo_user_id = todo.user_id
    @activity_user = User.find(activity_user_id)
    @activity = Activity.find(activity_id)
    users = User.find(todo.followers)
    users.each do |user|
      #Notification not created on your own action
      if activity_user_id != user.id.to_i
        user.add_to_notification activity_id
        increase_notification_pointer(user.notification_pointer)
      end
    end
    
    #even if creator of the todo does not follow the todo, he should be notified
    unless activity_user_id == todo_user_id 
      unless todo.followers.include? todo_user_id
        todo.user.add_to_notification activity_id
        increase_notification_pointer(todo.user.notification_pointer)
      end
    end

  end

  def discussion_notify_util discussion,activity_id,activity_user_id
    @project = discussion.discussable
    discussion_user_id = discussion.user_id
    @activity = Activity.find(activity_id)
    @log.debug "discussion_notify_util and project #{@project.name}"
    @project.users.each do |user|
      user.add_to_feed activity_id
    end
    
    followers = User.find(discussion.followers)
    followers.each do |user|
      unless user.id.to_i == activity_user_id
        user.add_to_notification activity_id
        increase_notification_pointer(user.notification_pointer)
      end
    end
    #even if creator of the discussion does not follow the discussion, he should be notified
    unless activity_user_id == discussion_user_id 
      unless discussion.followers.include? discussion.user_id
        @log.debug "since owner doesnot follow so notification items creation for user id #{discussion_user_id}"
        discussion.user.add_to_notification activity_id
        notification_count_pointer = "/messages/" + discussion_user_id.to_s + "/ncount"
        increase_notification_pointer(notification_count_pointer)
      end
    end

  end

end