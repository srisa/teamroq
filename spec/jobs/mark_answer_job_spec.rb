require 'rails_helper'

describe MarkAnswerJob do
  it "should process the job successfully" do
  	MarkAnswerJob.extend(Module.new { def award_teamplayer id ; end ; def award_good_answer id, qid; end; def increase_notification_pointer i; end})
  	@user = FactoryGirl.create(:user)
  	@a_user = FactoryGirl.create(:user)
  	@ac_user = FactoryGirl.create(:user)
  	@q_user = FactoryGirl.create(:user)
  	@question = FactoryGirl.create(:question, user_id: @user.id)
  	$redis.sadd @question.followers_key, @q_user.id
  	@answer = FactoryGirl.create(:answer,question_id: @question.id, user_id: @a_user.id, answer_mark: true)
  	@activity = FactoryGirl.create(:activity, user_id: @ac_user.id)
  	MarkAnswerJob.perform @activity.id, @answer.id
  	expect(@q_user.feed).to include @activity.id.to_s
  	expect(@user.feed).to include @activity.id.to_s
  end
end