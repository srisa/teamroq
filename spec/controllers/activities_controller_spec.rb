require 'rails_helper'

describe ActivitiesController do

  before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
      $redis.flushdb
  end

  describe "#index" do
    it "renders the template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "response code" do      
      get :index
      expect(response.status).to eq(200)
    end

    it "assigns activities correctly" do
      @question = FactoryGirl.create(:question)
      @activity = FactoryGirl.create(:activity)
      @user.add_to_feed @activity.id
      get :index
      expect(assigns(:activities)).to eq([@activity])
      expect(assigns(:more_results)).to eq(false)
    end
  end 
end
