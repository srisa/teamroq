class AnswerProcessingJob
  extend JobsHelper
	@queue = :answers
  @log = Logger.new 'log/resque.log'
	def self.perform activity_id,answer_id
		@answer = Answer.find(answer_id)
		@owner = @answer.user
		@question = @answer.question
    @question_owner = @question.user
    @activity = Activity.find(activity_id)
    @activity_user_id = @activity.user_id
    @users = User.find(@question.followers)
		@users.each do |user|
      user.add_to_feed activity_id
      user.save
		end

    #even if creator of the question does not follow the question, he should be notified
    unless @question.followers.include? @question_owner.id
     @question_owner.add_to_feed activity_id
     @question_owner.save
    end

    #add notification only if answer is added some one else
    unless @owner.id == @question_owner.id
      @question_owner.add_to_notification activity_id
      #notification bubble to be shown and feed under notification dropdown     
      increase_notification_pointer(@question_owner.notification_pointer)
      @question_owner.save
    end

		#leaderboard update
    @answer.topic_list.each do |t|
      if $redis.zscore("rep:topic:"+t,@owner.id).nil?
       $redis.zadd("rep:topic:"+t,POINTS_FOR_ANSWER,@owner.id)
      else
        $redis.zincrby("rep:topic:"+t,POINTS_FOR_ANSWER,@owner.id)
      end
    end

    award_teamplayer(@activity_user_id)
    award_proactive_answers(@activity_user_id,@question)
        
		# TODO all user followers get notified
	end
end