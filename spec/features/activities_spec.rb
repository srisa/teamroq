require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

feature "In the landing page" do
	before(:each) do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end

  scenario "Click on Projects" do
    visit("/activities")
    click_link("header-projects")
    expect(page).to have_content("Your Projects")
  end

  scenario "Click on Tasks" do
    visit("/activities")
    click_link("header-tasks")
    expect(page).to have_content("Your Tasks")
  end

  scenario "Click on Groups" do
    visit("/activities")
    click_link("header-groups")
    expect(page).to have_content("Your Groups")
  end

  scenario "Click on Documents" do
    visit("/activities")
    click_link("header-documents")
    expect(page).to have_content("Documents you have uploaded")
  end

  scenario "Click on Topics" do
    visit("/activities")
    click_link("header-topics")
    expect(page).to have_content("Welcome to Knowledge base")
  end

  scenario "Click on Profile" do
    visit("/activities")
    click_link("Profile")
    expect(page).to have_content("Skills")
    expect(page).to have_content("Badges")
    expect(page).to have_content("Description")
  end

  scenario "Click on Logout" do
    visit("/activities")
    click_link("Logout")
    expect(page).to have_content("You need to sign in or sign up before continuing")
  end

  feature "Activity feed" do

  end
end