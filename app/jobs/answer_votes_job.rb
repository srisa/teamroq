class AnswerVotesJob
  extend JobsHelper
	@queue = :avotes
	@log = Logger.new 'log/resque.log'
  
	def self.perform answer_id,vote
		@answer = Answer.find(answer_id)
		user_id = @answer.user_id
		marks = POINTS_FOR_VOTE*vote	
	  
	    @answer.topic_list.each do |t|      
	  	  $redis.zincrby("rep:topic:"+t,marks,user_id)
		  end
	    award_good_answer(user_id, marks)
	end
end