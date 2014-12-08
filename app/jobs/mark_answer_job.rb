class MarkAnswerJob
  extend JobsHelper
  @queue = :answers
  @log = Logger.new 'log/resque.log'
  def self.perform activity_id,answer_id
    @answer = Answer.find(answer_id)
    @owner = @answer.user
    @question = @answer.question
    @question_owner = @question.user
    @activity = Activity.find(activity_id)
    sign_factor = 1
    if !@answer.answer_mark
      sign_factor = -1
    else
      @log.debug "Adding feed items for accepted answer"
      followers = User.find(@question.followers)
      followers.push @question_owner
      followers.each do |user| 
        user.add_to_feed activity_id
        user.save
      end
    end

    mark =  sign_factor*POINTS_FOR_FINAL_ANSWER
    #leaderboard update
    # @answer.topic_list.each do |t|
    #   if $redis.zscore("rep:topic:"+t,@owner.id).nil?
    #    $redis.zadd("rep:topic:"+t,mark,@owner.id)
    #   else
    #     $redis.zincrby("rep:topic:"+t,mark,@owner.id)
    #   end
    # end
    @log.debug "Awarding good answer to user #{@owner.name} with marks #{mark}"
    award_good_answer(@owner.id, mark)
  end
end