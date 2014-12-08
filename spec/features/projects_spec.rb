require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Projects" do

  before :each do    
    @user = FactoryGirl.create(:user, :email => 'radada@ada.com')
    login_as(@user, :scope => :user)
  end

  describe "Post New Project" do

    before(:each) do
      visit '/projects/new'
    end

    it "adding a new project should work fine", :js => true do
      user_to_be_added = FactoryGirl.create(:user, :name => "John Cena", :email => 'cenajohn@a.com')
      fill_in 'project[description]', :with => "Description Project 1" 
      fill_in 'project[name]', :with => "Project1"
      fill_autocomplete 'user_list_tag', :with => 'John'
      page.execute_script("$('#new_project').submit()")
      expect(page).to have_content('Project1')
    end

    it "adding a new project with partial parameters should throw error", :js=> true do
      user_to_be_added = FactoryGirl.create(:user, :name => "John Cena", :email => 'cenajohn@a.com')
      fill_in 'project[description]', :with => "" 
      fill_in 'project[name]', :with => ""
      fill_autocomplete 'user_list_tag', :with => 'John'
      page.execute_script("$('#new_project').submit()")
      expect(page).to have_content('Please enter project name')
      expect(page).to have_content('Please enter project description')
    end

  end
  
  describe "Get Projects" do

    before(:each) do
      # Capybara.current_driver = :selenium
      newuser = FactoryGirl.create(:user, :name => "ProUser", :email => 'random123@a.com')
      newuser1 = FactoryGirl.create(:user, :name => "Randomuser", :email => 'random1234@a.com')
      @project = FactoryGirl.create(:project)
      todolist = FactoryGirl.create(:todo_list, project_id: @project.id)
      newuser.projects.push(@project) 
      newuser1.projects.push(@project) 
      @user.projects.push(@project)     
    end

    # it "adding a user to the project and showing it should work fine", :js => true do
    #   visit '/projects/' + @project.to_param
    #   user_to_be_added = FactoryGirl.create(:user, :name => "John Cena", :email => 'cenajohn@a.com')
    #   click_link 'Add Members'
    #   fill_autocomplete 'user_list_tag', :with => 'John'
    #   # Below click button doesnot work with webkit so use form submit instead
    #   # click_button 'Add Users'
    #   page.execute_script("$('#add-user-form').submit()")
    #   click_link  'Show Members'
    #   expect(page).to have_content('John Cena')

    # end


    

    it "adding task in tasklist should work fine", :js => true do
      visit '/projects/' + @project.to_param
      click_link 'Todolistdefault'
      click_link 'Add Task'
      fill_in 'todo[name]', :with => "Task1"
      fill_in 'todo[details]', :with => "Task1 Details"
      # fill_autocomplete "add-user1", :with => "Rand"
      fill_in 'todo[target_date]', :with => "12/12/2014"
      page.execute_script("$('#form-todo1').submit()")
      expect(page).to have_content("Task1")
      expect(page).to have_content("Task1 Details")    
    end

    it "adding incomplete task in tasklist should throw errors", :js => true do
      visit '/projects/' + @project.to_param
      click_link 'Todolistdefault'
      click_link 'Add Task'
      fill_in 'todo[name]', :with => ""
      fill_in 'todo[details]', :with => ""
      # fill_autocomplete "add-user1", :with => "Pro"
      fill_in 'todo[target_date]', :with => ""
      page.execute_script("$('#form-todo1').submit()")
      expect(page).to have_content("Please specify the title for this todo")
      expect(page).to have_content("Please describe this todo")
      expect(page).to have_content("Please specify the target_date")     
    end

  end

   
end 
