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

  def rating_key
    "answers:#{self.id}:rating"
  end

  def uprating_key
    "answers:#{self.id}:uprating"
  end

  def downrating_key
    "answers:#{self.id}:downrating"
  end

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


  def add_upvote user_id
    has_upvoted = $redis.sismember(uprating_key,user_id)
    has_downvoted = $redis.sismember(downrating_key,user_id)
    if !has_upvoted
      $redis.sadd(uprating_key, user_id)
      $redis.incr(rating_key)
      Resque.enqueue(AnswerVotesJob, self.id,1)
      if has_downvoted
        $redis.srem(downrating_key, user_id)
        $redis.incr(rating_key)
        Resque.enqueue(AnswerVotesJob, self.id,2)
      end
    end
    self.votes = $redis.get(rating_key)
  end

  def add_downvote id
    has_upvoted = $redis.sismember(uprating_key,user_id)
    has_downvoted = $redis.sismember(downrating_key,user_id)
    if !has_downvoted
      $redis.sadd(downrating_key, user_id)
      $redis.decr(rating_key)
      Resque.enqueue(AnswerVotesJob, self.id,-2)
      if has_upvoted
        $redis.srem(uprating_key, user_id)
        $redis.deccr(rating_key)
        Resque.enqueue(AnswerVotesJob, self.id,-1)
      end
    end
    self.votes = $redis.get(rating_key)
  end
end
