class TodoProcessingJob
  extend JobsHelper
  @queue = :todos
  @log = Logger.new 'log/resque.log'
  ################################################
  # 1) update all todo followers feed
  # 2) notify the assigned guy
  # this is currently missing out the guys on project
  ################################################
  def self.perform(activity_id, todo_id)
    todo = Todo.find(todo_id)
    activity = Activity.find(activity_id)
    activity_user_id = activity.user_id
    todo_notify_util todo,activity_id,activity_user_id
    
  end
end