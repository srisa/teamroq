require 'rails_helper'

describe "Devise routes" do

  it "valid login should sign in" do
  	@user = FactoryGirl.create(:user)
  	visit new_user_session_path
		fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: "foobar123"
    click_button "Login"
  	expect(page).to have_content "Signed in successfully"
  end

  it "invalid login should redirect with notice" do
    @user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: "fooba123"
    click_button "Login"
    expect(page).to have_content "Invalid"
    expect(page).to have_content "email"
    expect(page).to have_content "password"
  end

end
