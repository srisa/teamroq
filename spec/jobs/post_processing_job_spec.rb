require 'rails_helper'

describe PostProcessingJob do
  it "should process the job successfully" do
  	PostProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
    @user = FactoryGirl.create(:user)
    @group_user = FactoryGirl.create(:user)
    @group = FactoryGirl.create(:group)
    @group.users.push @group_user
    @post = FactoryGirl.create(:post, postable_type: "Group", postable_id: @group.id)
 	@activity = FactoryGirl.create(:activity)
 	PostProcessingJob.perform @activity.id, @post.id
 	expect(@group_user.feed).to include @activity.id.to_s
  end
end