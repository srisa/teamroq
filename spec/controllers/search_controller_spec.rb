require 'rails_helper'

describe SearchController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question, topic_list: "topic,test")
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end

  describe "GET autocomplete" do
  end

  describe "GET autocomplete_user" do
  end

  describe "GET autocomplete_tag" do
  end
end