require 'rails_helper'

describe NotificationsController do

  before(:each) do
      $redis.flushdb
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get :index, {format: "json"}
      expect(response).to be_success
    end

    it "assigns number" do
      key = "/messages/" + @user.id.to_s + "/ncount"
      $redis.set key, 4457
      get :index, {format: "json"}
      expect(assigns(:number)).to eq("4457")
      expect(response.body).to match /4457/
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get :show, {format: "json"}
      expect(response).to be_success
    end

    it "assigns the number" do
      get :show, {format: "json"}
      expect(assigns(:number)).to eq("0")
    end

    it "assigns activities" do
      @activities = FactoryGirl.create_list(:activity, 3)
      @activities.each do |activity|
        $redis.zadd(@user.notification_key, Time.now.to_i,activity.id)
      end
      get :show, {format: "json"}
      expect(assigns(:activities)).to eq(@activities.reverse)
    end
  end

  describe "GET 'showall'" do
    it "returns http success" do
      get :showall
      expect(response).to be_success
    end

    it "assigns activities" do
      @activities = FactoryGirl.create_list(:activity, 3)
      @activities.each do |activity|
       @user.add_to_notification activity.id
      end
      @activities[0].update_attributes(updated_at: 2.weeks.ago)      
      @activities[1].update_attributes(updated_at: 4.weeks.from_now)

      get :showall
      expect(assigns(:activities)).to eq([@activities[1], @activities[2], @activities[0]])
    end
  end

end
