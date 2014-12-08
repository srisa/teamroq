require "logger"
class VotesQuestionJob
    extend JobsHelper
	@queue = :qvotes
	@log = Logger.new 'log/resque.log'
	def self.perform question_id,vote
		@question = Question.find(question_id)
		user_id = @question.user_id
        marks = POINTS_FOR_VOTE*vote
        #@logger.debug "In QuestionVotesJob giving marks #{marks}"	
        @question.topic_list.each do |t|	      
#          $redis.zincrby("rep:topic:"+t,marks,user_id)      
        end
        award_good_question(user_id, marks)
	end
end