class QuestionProcessingJob
@queue = :questions
@logger = Logger.new 'log/resque.log'

	def self.perform activity_id, question_id
    @question = Question.find(question_id)
		@user = User.find(@question.user_id)
		#initmate all users followers
    @followers = User.find(@user.followers)
		@followers.each do |user|
      user.add_to_feed activity_id
      user.save
    end
    #intimate all topic followers
    @topics = ActsAsTaggableOn::Tag.where(name: @question.topic_list)
    @topics.each do |topic|
      followers = User.find(topic.followers)
      followers.each do |user|
        user.add_to_feed activity_id
		    user.save
      end
      #leader board part here awarding 5 points for questions
      # if $redis.zscore("rep:topic:"+t,@user.id).nil?
      #   $redis.zadd("rep:topic:"+t,POINTS_FOR_QUESTION,@user.id)
      # else
      #   $redis.zincrby("rep:topic:"+t,POINTS_FOR_QUESTION,@user.id)
      # end
	   end
  end
end