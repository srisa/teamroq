require 'rails_helper'

describe Announcement do

  it "has valid factory" do
    @annoucement = FactoryGirl.build(:announcement)
    expect(@annoucement).to be_valid
  end

  it "is invalid with out content" do
    @annoucement = FactoryGirl.build(:announcement, content: "")
    expect(@annoucement).not_to be_valid
  end

  it "is invalid with out group" do
    @annoucement = FactoryGirl.build(:announcement, announcable_id: "")
    expect(@annoucement).not_to be_valid
  end
end