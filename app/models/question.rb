class Question < ActiveRecord::Base
  include PgSearch
  include QuestionsHelper
  extend FriendlyId
  acts_as_ordered_taggable
  acts_as_ordered_taggable_on :topics

  pg_search_scope :search_name, :against => :title, :using => [:tsearch, :trigram]
  
  friendly_id :title, use: [:slugged, :finders]
  validates_presence_of :content, message: "can't be blank"
  validates_presence_of :title, message: "can't be blank"
  validates_presence_of :topic_list, message: "can't be blank"
  validate :tags_are_present

  belongs_to :user
  belongs_to :askable, :polymorphic => true
  has_one :activity, :as => :trackable,:dependent => :destroy
  has_many :answers
  has_many :comments, :as => :commentable
    
  delegate  :name , :to => :user, :prefix => true
  scope :latest_first, -> {order("created_at DESC")}
  scope :with_no_answers, -> {where(answers_count: 0)}
  scope :high_up_voted, -> {order("votes ASC")}

  class << self

    def find_questions_in_topic(topic)
      @questions = Question.tagged_with(topic)
    end

    def find_unanswered_questions_in_topic(topic)
      @questions = Question.tagged_with(topic).with_no_answers
    end

    def find_latest_questions_in_topic(topic)
      Question.tagged_with(topic).latest_first
    end

    def find_highest_voted_questions(topic)
      @questions = Question.tagged_with(topic).high_up_voted
      
    end

    def search(phrase)
      questions = Question.search_name(phrase).limit(5)
      questions.collect { |c| {"context" => "question", "id" => c["id"], "name" => c["title"], "path" => "/questions/#{c["id"]}"} }
    end
  end

end
