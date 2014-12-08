require 'rails_helper'

describe AnswerVotesJob do
  it "should process the job successfully" do
  	@user = FactoryGirl.create(:user)
  	@answer = FactoryGirl.create(:answer, user_id: @user.id)
  	AnswerVotesJob.extend(Module.new { def award_teamplayer id ; end ; def award_good_answer id, qid; end; def increase_notification_pointer i; end})
    AnswerVotesJob.perform @answer.id, 1
  end
end