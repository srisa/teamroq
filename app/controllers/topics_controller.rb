class TopicsController < ApplicationController
	before_filter :get_question_and_user
	
  def create
    
  end

  def destroy
  end

  private
  	def get_question_and_user
  		@question = Question.find(params[:id])
  		@user = current_user
  	end
end
