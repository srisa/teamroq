class Answer < ActiveRecord::Base
	#validations
	validates_presence_of :content, message: "can't be blank"
  validates_presence_of :question, :message => "cant be blank"
  
  #attr_accessible :content,:answer_mark

  belongs_to :user
  belongs_to :question, touch: true, counter_cache: true
  has_one :activity, :as => :trackable, :dependent => :destroy
  has_many :comments, :as => :commentable

  delegate :name, :to => :user, :prefix => true
  delegate :topics, :to=> :question
  delegate :topic_list, :to=> :question


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
  end


# IF the user has down voted, we remove his downvote and add his upvote

  def add_upvote user_id
    has_upvoted = self.up_votes.include? user_id
    has_downvoted = self.down_votes.include? user_id
    if !has_upvoted
      self.up_votes.push user_id
      Resque.enqueue(AnswerVotesJob, self.id,1)
    elsif has_downvoted
      self.down_votes.delete user_id
      self.up_votes.push user_id
      Resque.enqueue(AnswerVotesJob, self.id,2)
    end
  end

  def add_downvote id
    has_upvoted = self.up_votes.include? user_id
    has_downvoted = self.down_votes.include? user_id
    if !has_downvoted
      self.down_votes.push user_id
      Resque.enqueue(AnswerVotesJob, self.id,2)
    elsif has_upvoted
      self.up_votes.delete user_id
      self.down_votes.push user_id
      Resque.enqueue(AnswerVotesJob, self.id,1)
    end
  end
end
