require 'rails_helper'

describe QuestionProcessingJob do
  it "should process the job successfully" do
    @user = FactoryGirl.create(:user)
    @topic_user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question, user_id: @user.id, topic_list: "hello")
    @topic = ActsAsTaggableOn::Tag.where(name: "hello").first
    @activity = FactoryGirl.create(:activity)
    $redis.sadd @topic.followers_key, @topic_user.id
    QuestionProcessingJob.perform @activity.id, @question.id
    expect(@topic_user.feed).to include @activity.id.to_s
  end
end