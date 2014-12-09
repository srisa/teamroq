require 'rails_helper'

describe AnswerProcessingJob do
  before(:each) do
    $redis.flushdb
  end
  
  it "should process the job successfully" do
  	AnswerProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_answers id, qid; end; def increase_notification_pointer i; end})
    @user = FactoryGirl.create(:user)
    @s_user = FactoryGirl.create(:user)
    @a_user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question,user_id: @user.id)
    $redis.sadd @question.followers_key, @s_user.id
    @answer = FactoryGirl.create(:answer, question_id: @question.id, user_id: @a_user.id)
  	@activity = FactoryGirl.create(:activity, user_id: @user.id)
  	AnswerProcessingJob.perform @activity.id, @answer.id
  	expect(@s_user.feed).to include @activity.id.to_s
  	expect(@user.notifications).to include @activity.id.to_s
  	expect(@user.feed).to include @activity.id.to_s
  end
end