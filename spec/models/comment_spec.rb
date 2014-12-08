require 'rails_helper'

describe Comment do

  context "factories" do
    before(:each) do
      @comment = FactoryGirl.build(:comment)
    end

  
    it "should have a valid factory" do
      expect(@comment).to be_valid
    end
  end

  it "should have some content" do
    @comment = FactoryGirl.build(:comment, content: nil)
    expect(@comment).not_to be_valid
  end

  it "should have a user" do
    @comment = FactoryGirl.build(:comment)
    @comment.user = nil
    expect(@comment).not_to be_valid
  end

end
