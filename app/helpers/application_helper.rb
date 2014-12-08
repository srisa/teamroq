module ApplicationHelper

  def track_activity_create(trackable, action = params[:action])
    affected = trackable.postable
    path = '/' + affected.class.name.downcase + 's/' + affected.id.to_s + "/posts/" + trackable.id.to_s
    logger.debug "in track_activity path #{path}"
    a = current_user.activities.create! action: action,
          trackable: trackable, affected: affected, path: path
    Resque.enqueue(PostProcessingJob, a.id, trackable.id)  
  end

  def track_activity(trackable, action = params[:action])
    a = trackable.activity
    Resque.enqueue(PostProcessingJob, a.id, trackable.id)  
  end

  def track_discussion_activity_create(trackable, action = params[:action])
    affected = trackable.discussable
    path = '/' + affected.class.name.downcase + 's/' + affected.id.to_s + '/discussions/' + trackable.id.to_s
    logger.debug "in track_activity path #{path}"
    a = current_user.activities.create! action: action,
          trackable: trackable, affected: affected, path: path
    Resque.enqueue(DiscussionProcessingJob, a.id, trackable.id)  
  end

  def track_discussion_activity(trackable, action = params[:action])
    a =  trackable.activity
    a.update_attributes(action: action)
    Resque.enqueue(DiscussionProcessingJob, a.id, trackable.id)  
  end

  def track_answer_activity_create(trackable, action = params[:action])
    affected = trackable.question
    path = '/questions/' + affected.id.to_s
    a = current_user.activities.create! action: action,
          trackable: trackable, affected: affected, path: path
    if action == "create"
      Resque.enqueue(AnswerProcessingJob, a.id, trackable.id)
    else
      Resque.enqueue(MarkAnswerJob, a.id, trackable.id)
    end  
  end

  def track_answer_activity(trackable, action = params[:action])
    a =  trackable.activity
    a.update_attributes(action: action)
    if action == "update"
     Resque.enqueue(AnswerProcessingJob, a.id, trackable.id)
    else
      Resque.enqueue(MarkAnswerJob, a.id, trackable.id)
    end  
  end

  def track_question_activity_create(trackable, action = params[:action])
    path = '/questions/' + trackable.id.to_s
    a = current_user.activities.create! action: action, 
          trackable: trackable, path: path
    Resque.enqueue(QuestionProcessingJob, a.id, trackable.id)  
  end

  def track_question_activity(trackable, action = params[:action])
    a = trackable.activity
    a.update_attributes(action: action)
    Resque.enqueue(QuestionProcessingJob, a.id, trackable.id)  
  end

  def track_document_activity_create(trackable, action = params[:action])
    affected = trackable.attachable
    a = current_user.activities.create! action: action, 
          trackable: trackable, affected: affected
    Resque.enqueue(DocumentProcessingJob, a.id, trackable.id)  
  end

  def track_document_activity(trackable, action = params[:action])
    a = trackable.activity
    a.update_attributes(action: action)
    Resque.enqueue(DocumentProcessingJob, a.id, trackable.id)  
  end

  def track_todo_activity(trackable, action = params[:action])
    a =  trackable.activities.where(:action => ["create","reopen","close"]).first
    unless a
      a = create_activity_for_todo trackable, action
    else 
      a.update_attributes(action: action, user: current_user)
    end
    Resque.enqueue(TodoProcessingJob, a.id, trackable.id)  
  end

  def track_todo_activity_change_user(trackable, action = params[:action])
    a =  trackable.activities.where(:action => "user").first
    unless a
      a = create_activity_for_todo trackable, "user"
    end
    Resque.enqueue(TodoProcessingJob, a.id, trackable.id)  
  end

  def track_todo_activity_change_date(trackable, action = params[:action])
    a =  trackable.activities.where(:action => "date").first
    unless a
      a = create_activity_for_todo trackable, "date"
    end
    Resque.enqueue(TodoProcessingJob, a.id, trackable.id)  
  end

  def track_todo_list_activity_create(trackable, action = params[:action])
    affected = trackable.project
    path = '/projects/' + affected.id.to_s
    a = current_user.activities.create! action: action,
          trackable: trackable,affected: affected, path: path
    Resque.enqueue(TodoListProcessingJob, a.id, trackable.id)  
  end

  def track_todo_list_activity(trackable, action = params[:action])
  end

  def track_comment_activity_create(trackable, action = params[:action])
    affected = trackable.commentable
    logger.debug "affected #{affected.attributes.inspect}"
    if affected.is_a? Todo
      a = affected.activities.where(:action => "comment").first
      unless a
        a = create_activity_for_todo affected, "comment"
      end 
    else
      a = affected.activity
    end
    logger.debug "activity #{a}"
    a.update_attributes(action: "comment", user: current_user, updated_at: Time.now)
    Resque.enqueue(CommentProcessingJob, a.id, trackable.id)  
  end

  def track_comment_activity(trackable, action = params[:action])
    affected = trackable.commentable
    a = affected.activity
    a.update_attributes(action: "comment")
    Resque.enqueue(CommentProcessingJob, a.id, trackable.id)
  end

  def create_activity_for_todo trackable,action
    affected = trackable.todo_list
    todo_list =  TodoList.find(affected.id)
    project = todo_list.project
    path = '/projects/' +project.id.to_s + '/todo_lists/' + affected.id.to_s
    a =  current_user.activities.create! action: action,
          trackable: trackable, affected: affected, path: path
    a
  end
end
