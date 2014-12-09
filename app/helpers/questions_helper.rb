module QuestionsHelper

  def rating
    $redis.get rating_key
  end

  def add_vote value ,current_user_id
    if value == 1
      add_upvote current_user_id
    else
      add_downvote current_user_id
    end
  end

  def add_upvote voter_user_id
    has_upvoted = $redis.sismember(uprating_key,user_id)
    has_downvoted = $redis.sismember(downrating_key,user_id)
    if !has_upvoted
      $redis.sadd(uprating_key, user_id)
      $redis.incr(rating_key)
      Resque.enqueue(VotesQuestionJob, self.id,1)
      if has_downvoted
        $redis.srem(downrating_key, user_id)
        $redis.incr(rating_key)
        Resque.enqueue(VotesQuestionJob, self.id,2)
      end
    end
    self.votes = $redis.get(rating_key)
  end

  def add_downvote voter_user_id
    has_upvoted = $redis.sismember(uprating_key,user_id)
    has_downvoted = $redis.sismember(downrating_key,user_id)
    if !has_downvoted
      $redis.sadd(downrating_key, user_id)
      $redis.decr(rating_key)
      Resque.enqueue(VotesQuestionJob, self.id,-2)
      if has_upvoted
        $redis.srem(uprating_key, user_id)
        $redis.deccr(rating_key)
        Resque.enqueue(VotesQuestionJob, self.id,-1)
      end
    end
    self.votes = $redis.get(rating_key)
  end


  private

    def tags_are_present
        if topic_list.empty?
          errors.add :base, "Please tag the question to atleast one topic."
        end
    end

end
