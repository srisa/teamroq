require 'rails_helper'

describe Activity do
  before(:all) do
    @user = FactoryGirl.create(:user, email: "test@aa.com")
    @question = FactoryGirl.create(:question)
    @activity = @user.activities.create(action: "edit",trackable: @question, affected: @question , path: "/questions/2/test")
  end

  it "is valid" do
    expect(@activity).to be_valid
  end

  it "#updated_at_words" do
    expect(@activity.updated_at_words).not_to be_nil
  end

  context "affected_name" do
    it "is not nil" do
      expect(@activity.affected_name).to eq(@question.title)
    end

    it "is nil" do
      @a = @user.activities.create(action: "edit",trackable: @question, affected: nil , path: "/questions/2/test")
      expect(@a.affected_name).to be_nil
    end
  end

  context "trackable_name" do
    it "is not nil" do
      expect(@activity.trackable_name).to eq(@question.title)
    end

    it "is nil" do
      @a = @user.activities.create(action: "edit",trackable: nil, affected: @question , path: "/questions/2/test")
      expect(@a.trackable_name).to be_nil
    end
  end

  context "scopes" do
    it "today" do
      @activity = @user.activities.create(action: "edit",trackable: @question, affected: @question , path: "/questions/2/test")
      @today = @user.activities.today
      expect(@today).to include(@activity)
    end

    it "this week" do
      @activity = @user.activities.create(action: "edit",trackable: @question, affected: @question , path: "/questions/2/test")
      @this_week = @user.activities.this_week
      expect(@this_week).to be_empty
    end
  end



end
