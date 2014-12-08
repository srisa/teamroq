require 'rails_helper'

describe Question do

  before(:each) do
    @question = FactoryGirl.create(:question)
  end
    	
  it "has a valid factory" do  
    expect(@question).to be_valid
  end

  it "should not created with out any content" do
    @question = FactoryGirl.build(:question, content: "")
    expect(@question).not_to be_valid
  end

  it "should not updated with out any content" do
    @question.update_attributes(content: "")
    expect(@question).not_to be_valid
  end

  it "should not created with out any title" do
    @question = FactoryGirl.build(:question, title: "")
    expect(@question).not_to be_valid
  end

  it "should not updated with out any title" do
    @question.update_attributes(title: "")
    expect(@question).not_to be_valid
  end


  it "should not created with out any tags" do
    @question = FactoryGirl.build(:question, topic_list: "")
    expect(@question).not_to be_valid
  end

  it "should not updated with out any tags" do
    @question.update_attributes(topic_list: "")
    expect(@question).not_to be_valid
  end

  it "has a slug after creation" do
    expect(@question.slug).not_to be_nil
    expect(@question.slug).to include "randomquestion"
  end

  context "Voting" do
    before(:each) do
      @question = FactoryGirl.create(:question)
      @user = FactoryGirl.create(:user)
      ResqueSpec.reset!
    end

    it "upvote should increase rating" do    
      @question.add_vote 1, @user.id
      expect(@question.votes).to eq(1)
    end

    it "downvote should decrease rating" do
      @question.add_vote -1 ,@user.id
      expect(@question.votes).to eq(-1)
    end

    it "repeated upvoting should not work" do
      @question.add_vote 1, @user.id
      @question.add_vote 1, @user.id
      @question.add_vote 1, @user.id
      expect(@question.votes).to eq(1)
    end

    it "repeated downvoting should not work" do
      @question.add_vote -1, @user.id
      @question.add_vote -1, @user.id
      @question.add_vote -1, @user.id
      expect(@question.votes).to eq(-1)
    end

    context "Jobs" do

      it "downvote should queue an item" do
        @question.add_vote -1 ,@user.id
        expect(VotesQuestionJob).to have_queued(@question.id, 2).in(:qvotes) 
      end

      it "upvote should queue an item" do
        @question.add_vote 1 ,@user.id
        expect(VotesQuestionJob).to have_queued(@question.id, 1).in(:qvotes)
      end
    end

  end


end
