require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Todos" do

  before :each do
    @user = FactoryGirl.create(:user)    
    login_as(@user, :scope => :user)
  end
  
  describe "Get Todos" do

    before(:each) do
      @project = FactoryGirl.create(:project)
      @todolist = FactoryGirl.create(:todo_list, project_id: @project.id)
      @user.projects.push(@project)
      @todo = FactoryGirl.create(:todo, :name => 'Todo1', :details => 'Detail1', :user_id => newuser.id,todo_list_id: @todolist.id)
      visit '/todo_lists/'+ @todolist.id +'/todos/' + @todo.id
    end

    it "following a todo should work fine",:js => true do  
      expect(page).to have_content('Todo1')
      expect(page).to have_content('Detail1')
      click_link 'Follow'
      expect(page).to have_content 'Unfollow'
      click_link 'Unfollow'
      expect(page).to have_content 'Follow'

    end  

    it "changing user should work fine",:js => true do      
      click_link 'change-user-link'
      fill_autocomplete 'search-user', :with => 'John'
      page.execute_script %Q{ $('#form-change-user').submit() }
      expect(page).to have_content('John Cena')
    end

    it "changing date should work fine",:js => true do      
      click_link 'change-date-link'
      fill_in 'calendar-field', :with => '12-12-2014'
      page.execute_script %Q{ $('#form-change-date').submit() }
      expect(page).to have_content('12 Dec 2014')
    end    

    it "adding comment case", :js => true do
      fill_in 'comment[content]', :with => ""
      click_button "Submit"
      expect(page).to have_content("Please enter something in comments before submitting")
      fill_in 'comment[content]', :with => "Comment awesome"
      click_button "Submit"
      expect(page).to have_content("Comment awesome")
    end  

  end

   
end 
