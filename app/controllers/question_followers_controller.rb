class QuestionFollowersController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :get_user

def create
  unless @question.followers.include? current_user.id
    @question.followers.push current_user.id
    @question.followers_will_change!
  end  
  @question.save
  @followers_count = @question.followers.length
  render 'questions/follow' 		
end

def destroy
  if @question.followers.include? current_user.id
    @question.followers.delete current_user.id
    @question.followers_will_change! 
  end
  @question.save
  @followers_count = @question.followers.length
  render 'questions/follow'  
end

private
	def get_user
		@user = current_user
		@question = Question.find(params[:id])
	end

end
