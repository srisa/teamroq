module QuestionsHelper

  def rating
    up_votes = self.up_votes.length
    down_votes = self.down_votes.length
    up_votes - down_votes
  end

  def add_vote value ,current_user_id
    if value == 1
      add_upvote current_user_id
    else
      add_downvote current_user_id
    end
    self.votes = self.rating
  end

# IF the user has down voted, we remove his downvote and add his upvote

  def add_upvote voter_user_id
    has_upvoted = self.up_votes.include? voter_user_id
    has_downvoted = self.down_votes.include? voter_user_id
    if !has_upvoted
      self.up_votes.push voter_user_id
      Resque.enqueue(VotesQuestionJob, self.id,1)
    elsif has_downvoted
      self.down_votes.delete voter_user_id
      self.up_votes.push voter_user_id
      Resque.enqueue(VotesQuestionJob, self.id,2)
    end
  end

  def add_downvote voter_user_id
    has_upvoted = self.up_votes.include? voter_user_id
    has_downvoted = self.down_votes.include? voter_user_id
    if !has_downvoted
      self.down_votes.push voter_user_id
      Resque.enqueue(VotesQuestionJob, self.id,2)
    elsif has_upvoted
      self.up_votes.delete voter_user_id
      self.down_votes.push voter_user_id
      Resque.enqueue(VotesQuestionJob, self.id,1)
    end
  end


  private
  def tags_are_present
      if topic_list.empty?
        errors.add :base, "Please tag the question to atleast one topic."
      end
  end

end
