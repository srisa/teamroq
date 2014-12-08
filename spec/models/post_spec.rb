require 'rails_helper'

describe Post do
  
  before(:each) do
  	@post = FactoryGirl.build(:post)
  end

  it "has valid factory" do
  	expect(@post).to be_valid
  end

  it "is invalid with out content" do
  	@post = FactoryGirl.build(:post, content: "")
  	expect(@post).not_to be_valid
  end

  it "is invalid with out user" do
  	@post = FactoryGirl.build(:post, user_id: "")
  	expect(@post).not_to be_valid
  end


end
