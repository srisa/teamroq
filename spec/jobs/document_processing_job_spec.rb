require 'rails_helper'

describe DocumentProcessingJob do
  it "should process the job successfully" do
    DocumentProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
  	@project = FactoryGirl.create(:project)
  	@document = FactoryGirl.create(:document, attachable_type: "Project", attachable_id: @project.id)
  	@user = FactoryGirl.create(:user)
  	@activity = FactoryGirl.create(:activity)
  	@user.projects.push @project
  	DocumentProcessingJob.perform @activity.id, @document.id
  	@user.reload	
  	expect(@user.feed).to include @activity.id
  end
end