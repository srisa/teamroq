require 'rails_helper'

describe QuestionProcessingJob do
  it "should process the job successfully" do
    @user = FactoryGirl.create(:user)
    @topic_user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question, user_id: @user.id, topic_list: "hello")
    @topic = ActsAsTaggableOn::Tag.where(name: "hello").first
    @activity = FactoryGirl.create(:activity)
    @topic.followers.push @topic_user.id
    @topic.followers_will_change!
    @topic.save
    QuestionProcessingJob.perform @activity.id, @question.id
    @topic_user.reload
    expect(@topic_user.feed).to include @activity.id
  end
end