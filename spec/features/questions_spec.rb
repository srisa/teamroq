require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# After { Warden.test_reset! }


describe "Questions" do

  before :each do
    user = FactoryGirl.create(:user)    
    login_as(user, :scope => :user)
    create_badges
  end
  
  describe "GET /questions/new" do

    it "question form should submit with all the fields filled and extra topics 
    should be present when topics show page is visited" do
        visit '/questions/new'
        page.should have_content("Add a Question")
        find(:xpath, "//input[@id='question_topic_list']").set "tag1,tag2"
        fill_in 'question[title]', :with => "Title for this question"
        fill_in 'question[content]', :with => "content for this question" 
        click_button "Add Question"
        page.should have_content("Title for this question")
        visit questions_path
        page.should have_content("Topics")
        page.should have_content("tag1".capitalize)
      
    end

	  it "question form should not submit with partial fields filled", :js => true do
      visit '/questions/new'
      page.should have_content("Add a Question")
      fill_in 'question[title]', :with => "Title for this question" 
      fill_in 'question[content]', :with => "" 
      click_button "Add Question"
      page.should have_content("Please assign this question to some topics")
      page.should have_content("Please describe this question")
      current_path.should == '/questions/new'
      
	  end
  end

   describe "GET /questions/:id" do

    before(:each) do
      # Capybara.current_driver = :selenium
      newuser = FactoryGirl.create(:user, :email => 'random123@a.com')
      id = newuser.id
      # logger.debug "user name is #{newuser.attributes.inspect}"
      FactoryGirl.create(:question, :topic_list => 'tag1', :user_id => id)
      visit '/questions/1'
    end

     it "follow unfollow question should work fine", :js => true do     
      # Finding follow button and clicking it
      page.should have_css('a.follow', :text => 'Follow')
      find('a.follow', :text => 'Follow').click
      #Getting unfollow button and clicking it
      page.should have_content('Unfollow')
      page.should have_content('1 Follower')
      page.should have_css('a.unfollow', :text => 'Unfollow')
      find('a.unfollow', :text => 'Unfollow').click      
      page.should have_content('0 Followers')      
    end

    it "upvote downvote should work fine", :js => true do     
      # Finding follow button and clicking it
      # save_and_open_page
      page.should have_css('a#upvote-question1')
      page.should have_css('a#downvote-question1')
      votenumber = find('a#votenumber-question1').text.to_i
      click_link('upvote-question1')
      # VotesQuestionJob.should have_queue_size_of(1)
      page.should have_css('a#votenumber-question1', :text => votenumber+1)
      click_link 'downvote-question1'
      page.should have_css('a#votenumber-question1', :text => votenumber-1)
    end

  end

  describe "Topics show pages test cases with js true and webkit" do
    
     before(:each) do
      # Capybara.current_driver = :selenium
      qcount = 6 
        qcount.times do 
          FactoryGirl.create(:question, :topic_list => 'tag1')
        end
        visit '/topics/tag1'
     end

    it "number of questions tagged should update after adding new question" do
      page.has_css?('span.no-of-qs-tagged', :text => '#{qcount}')
      FactoryGirl.create(:question, :topic_list => 'tag1')
      visit '/topics/tag1'
      # qcount = qcount+1
      page.has_css?('span.no-of-qs-tagged', :text => '#{qcount}'.to_i+1)
    end

    it "follow unfollow should work fine", :js => true do     
      # Finding follow button and clicking it
      page.has_css?('a.follow-topic', :text => 'Follow')
      find('a.follow-topic', :text => 'Follow').click
      #Getting unfollow button and clicking it
      page.should have_content('Unfollow')
      page.should have_content('1 Follower')
      page.has_css?('a.unfollow-topic', :text => 'Unfollow')
      find('a.unfollow-topic', :text => 'Unfollow').click      
      page.should have_content('0 Followers')      
    end

  end


  

end 
