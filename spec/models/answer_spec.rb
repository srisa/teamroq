require 'rails_helper'

describe Answer do
  before(:each) do
    @answer = FactoryGirl.create(:answer)
  end

  it "should have valid factory" do
    expect(@answer).to be_valid
  end
  
  it "should not be created with out any content" do
    @answer = FactoryGirl.build(:answer, content: "")
    expect(@answer).not_to be_valid
  end

  it "should not be updated with out any content" do   
    @answer.update_attributes(:content=>"")
    expect(@answer).not_to be_valid
  end

  it "should have a question" do
    @answer = Answer.create({:content=> "My Name is Sri"})
    expect(@answer).not_to be_valid
  end

  context "Voting" do
    before(:each) do
      @answer = FactoryGirl.create(:answer)
      @user = FactoryGirl.create(:user)
    end

    it "upvote should increase rating" do    
      @answer.add_vote 1 ,@user.id
      expect(@answer.rating).to eq(1)
    end

    it "downvote should decrease rating" do
      @answer.add_vote -1 ,@user.id
      expect(@answer.rating).to eq(-1)
    end

    it "repeated upvoting should not work" do
      @answer.add_vote 1 ,@user.id
      @answer.add_vote 1 ,@user.id
      @answer.add_vote 1 ,@user.id
      expect(@answer.rating).to eq(1)
    end

    it "repeated downvoting should not work" do
      @answer.add_vote -1 ,@user.id
      @answer.add_vote -1 ,@user.id
      @answer.add_vote -1 ,@user.id
      expect(@answer.rating).to eq(-1)
    end
  end
end


