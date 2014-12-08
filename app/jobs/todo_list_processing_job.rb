####
class TodoListProcessingJob
  @queue = :todo_lists
  @logger = Logger.new 'log/resque.log'
  def self.perform activity_id, todo_list_id
    @todo_list = TodoList.find(todo_list_id)
    @project = @todo_list.project
    @project.users.each do |user|
    	user.add_to_feed activity_id
    	user.save
    end
  end
  
end