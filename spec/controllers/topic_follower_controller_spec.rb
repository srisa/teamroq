require 'rails_helper'

describe TopicFollowerController do

  before(:each) do
    $redis.flushdb
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question, topic_list: "test")
    sign_in @user
  end

  describe "PATCH create" do
    describe "template" do
      subject {patch :create, {name: "test", format: 'js'} }
      it "renders correctly" do
        expect(subject).to render_template("topics/follow")
      end
    end

    it "assigns followers count" do
      patch :create, {name: "test", format: 'js'}
      expect(assigns(:followers_count)).to eq(1)
    end
  end

  describe "PATCH destroy" do
    describe "template" do
      subject {patch :destroy,{name: "test", format: 'js'} }
      it "renders correctly" do 
        expect(subject).to render_template("topics/follow")
      end
    end
    it "assigns followers count" do
      @question = FactoryGirl.create(:question, topic_list: "test_follow")
      @topic = ActsAsTaggableOn::Tag.where(name: "test_follow").first
      $redis.sadd @topic.followers_key, @user.id
      patch :destroy, {name: "test_follow", format: 'js'}
      expect(assigns(:followers_count)).to eq(0)
    end
  end

end
