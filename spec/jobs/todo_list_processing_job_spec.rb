require 'rails_helper'

describe TodoListProcessingJob do
  it "should process the job successfully" do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    @todo_list = FactoryGirl.create(:todo_list, project_id: @project.id)
    @user.projects.push @project
    @activity = FactoryGirl.create(:activity)
    TodoListProcessingJob.perform @activity.id, @todo_list.id
  	expect(@user.feed).to include @activity.id.to_s
  end
end