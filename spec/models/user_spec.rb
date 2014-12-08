require 'rails_helper'

describe User do

   it "has valid factory" do
      @user = FactoryGirl.build(:user)
      expect(@user).to be_valid
    end

  context "create" do
    it "should not be created with out a name" do
      @user = FactoryGirl.build(:user, name: "")
      expect(@user).not_to be_valid
    end

    it "should not be created with out email" do
      @user = FactoryGirl.build(:user, email: "")
      expect(@user).not_to be_valid
    end

    it "has a slug after creation" do
      @user = FactoryGirl.create(:user, name: "jim")
      expect(@user.slug).not_to be_nil
      expect(@user.slug).to match /jim/i
    end
  end

  context "update" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    it "should not be updated with out a name" do
      @user.update_attributes(name: "")
      expect(@user).not_to be_valid
    end

    it "should not be updated with out email" do
      @user.update_attributes(email: "")
      expect(@user).not_to be_valid
    end
  end

  it ".admin?" do
    @user = FactoryGirl.create(:user)
    @user.add_role :admin
    expect(@user.is_admin?).to be_truthy
  end
end
