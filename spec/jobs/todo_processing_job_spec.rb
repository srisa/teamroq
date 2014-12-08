require 'rails_helper'

describe TodoProcessingJob do
  it "should process the job successfully" do
  	TodoProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
    @p_user = FactoryGirl.create(:user)
    @t_user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    @todo_list = FactoryGirl.create(:todo_list, project_id: @project.id)
    @todo = FactoryGirl.create(:todo, todo_list_id: @todo_list.id, user_id: @t_user.id)
    @project.users.push @p_user
    @activity = FactoryGirl.create(:activity, user_id: @t_user.id)
    TodoProcessingJob.perform @activity.id, @todo.id
    @p_user.reload
    @t_user.reload
    expect(@p_user.feed).to include @activity.id
    expect(@t_user.feed).to eq([])   
  end
end