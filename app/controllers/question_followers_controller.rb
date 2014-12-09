class QuestionFollowersController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :get_user

  def create
    $redis.sadd @question.followers_key, current_user.id
    $redis.sadd current_user.questions_following_key, @question.id
    @followers_count = $redis.scard @question.followers_key
    render 'questions/follow' 		
  end

  def destroy
    $redis.srem @question.followers_key, current_user.id
    $redis.srem current_user.questions_following_key, @question.id
    @followers_count = $redis.scard @question.followers_key
    render 'questions/follow'  
  end

  private

  	def get_user
  		@user = current_user
  		@question = Question.find(params[:id])
  	end

end
