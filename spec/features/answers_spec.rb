require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Answers" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as(@user, :scope => :user)
      new_user = FactoryGirl.create(:user)
      id = new_user.id
      @question = FactoryGirl.create(:question, :topic_list => 'tag1', :user_id => id)
      FactoryGirl.create(:answer, :question_id => @question.id, :user_id => id)
      @comment = FactoryGirl.create(:comment, :commentable_id => @question.id, :commentable_type => 'Question',
        :user_id => id)
    end

    scenario "posting answer should work fine" do
      visit '/questions/' + @question.to_param 
      expect(page).to have_content("1 Answer", :count => 1)
      fill_in 'answer[content]', :with => "This is my answer to this problem"
      click_button "Answer"
      expect(page).to have_content("This is my answer to this problem")
      expect(page).to have_content("2 Answers", :count => 1)
    end

    it "posting empty answer should throw js error", js: true do
      visit '/questions/' + @question.to_param 
      accept_alert do
        click_button "Answer"
      end
      expect(page).to have_content("1 Answer", :count => 1)    
    end


    scenario "upvoting answer should work fine", js: true do
      @user = FactoryGirl.create(:user)
      @question = FactoryGirl.create(:question, :topic_list => 'tag1', :user_id => @user.id)
      @answer= FactoryGirl.create(:answer, :question_id => @question.id, :user_id => @user.id)
      visit "/questions/" + @question.to_param
      id = @answer.id.to_s
      expect(page).to have_css('a#upvote-answer'+ id)
      expect(page).to have_css('a#downvote-answer'+ id)
      votenumber = find('a#votenumber-answer'+ id).text.to_i
      click_link('upvote-answer'+ id)
      expect(page).to have_css('a#votenumber-answer'+ id, :text => votenumber+1)
      click_link 'downvote-answer'+ id
      expect(page).to have_css('a#votenumber-answer'+ id, :text => votenumber-1)
    end

    # scenario "entering comments should work fine for questions", :js => true do
    #   visit '/questions/' + @question.to_param 
    #   qid = @question.id.to_s
    #   expect(page).to have_css('a#show-comment-btn-question' + qid, :text => '1 Comment')
    #   click_link("1 Comment")
    #   save_and_open_page
    #   fill_in 'comment-box-question' + qid, :with => "This is my comment"
    #   page.execute_script("$('#question" + qid + "-comment-form').submit()")
    #   expect(page).to have_content('This is my comment')
    #   expect(page).to have_css('a#show-comment-btn-question' + qid, :text => '2 Comments')
    # end


    # it "entering empty comments should not be submitted for question", :js => true do
    #   page.should have_css('a#show-comment-btn-question1', :text => '1 Comment')
    #   fill_in 'comment-box-question1', :with => ""
    #   page.execute_script("$('#question1-comment-form').submit()")
    #   page.should have_content('Please enter something in comments before submitting')
    # end

    # it "entering comments should work fine for answers", :js => true do
    #   page.should have_css('a#show-comment-btn-answer1', :text => '0 Comments')
    #   fill_in 'comment-box-answer1', :with => "This is my answer comment"
    #   page.execute_script("$('#answer1-comment-form').submit()")
    #   page.should have_content('This is my answer comment')
    #   page.should have_css('a#show-comment-btn-answer1', :text => '1 Comment')
    # end

    # it "entering empty comments should not be submitted for answers", :js => true do
    #   page.should have_css('a#show-comment-btn-answer1', :text => '0 Comments')
    #   fill_in 'comment-box-answer1', :with => ""
    #   page.execute_script("$('#answer1-comment-form').submit()")
    #   page.should have_content('Please enter something in comments before submitting')
    # end
  
end 
