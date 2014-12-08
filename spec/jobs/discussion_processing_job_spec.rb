require 'rails_helper'

describe DiscussionProcessingJob do
  it "should process the job successfully" do
  	DiscussionProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
  	@user = FactoryGirl.create(:user)
  	@a_user = FactoryGirl.create(:user)
  	@p_user = FactoryGirl.create(:user)
  	@d_user = FactoryGirl.create(:user)
  	@project = FactoryGirl.create(:project)
  	@p_user.projects.push @project
  	@discussion = FactoryGirl.create(:discussion, discussable_type: "Project", discussable_id: @project.id, user_id: @user.id)
  	@discussion.followers.push @d_user
  	@discussion.followers_will_change!
  	@discussion.save
    @activity = FactoryGirl.create(:activity, user_id: @a_user.id)
  	DiscussionProcessingJob.perform @activity.id, @discussion.id
  	@user.reload
  	@a_user.reload
  	@p_user.reload
  	@d_user.reload
  	expect(@user.notifications).to include @activity.id
  	expect(@p_user.feed).to include @activity.id
  	expect(@d_user.notifications).to include @activity.id
  end
end