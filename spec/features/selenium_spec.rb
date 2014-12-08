require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Selenium Specs" do

  before :each do
    user = FactoryGirl.create(:user)    
    login_as(user, :scope => :user)
    FactoryGirl.create(:type)
    6.times do 
        FactoryGirl.create(:question, :topic_list => 'tag1')
    end
  end
  
 
  it "topics show page should have infinite scrolling", :js => true,  driver: :selenium  do
    visit '/topics/tag1'      
    page.has_css?('div.paginable')
    count = page.all('a', :text => 'tag1').length
    page.should have_content('tag1', :count => count)
    page.execute_script("$('html, body').scrollTop( $(document).height() - $(window).height() );")
    page.should have_content('tag1', :count => 7)
    # find(".newest-tab").click
    # page.has_css?('a.newest-tab')
    # page.has_no_content?('tag4')
    # page.should_not have_xpath("//a[@class='primary label' and text()='tag4']")
    # save_and_open_page
    # count = page.all(:css, 'a.primary.label').length
    # print page.html
    
    # page.should have_xpath("//a[@class='primary label' and text()='tag4']", :count => 3)
    
    # page.driver.evaluate_script("$('html, body').scrollTop( $(document).height() - $(window).height() );")
    # page.execute_script('window.scrollTo(0,100000)')
    # print page.html
    # sleep 20
    # newcount = page.all(:xpath, '//a[@class="primary label"]').length
    # page.should have_css('a.primary.label', :count => 6)
    
    # newcount = page.all(:xpath, "//a[@class='primary label']").length
    # save_and_open_page
    # newcount.should eql(count+1)

    # page.should have_xpath("//a[@class='primary label' and text()='tag4']", :count => 4)
    # page.should have_xpath("//a[@class='info label' and text()='tag4']")
  end


end 
