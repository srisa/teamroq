require 'rails_helper'

describe FollowersController do
	
	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

	describe "POST create" do
		subject {patch :create, {id: @user.id, format: 'js'} }
		it "renders correctly" do
			expect(subject).to render_template("users/userfollow")
		end
	end

	describe "DELETE destroy" do
		subject {patch :destroy, {id: @user.id, format: 'js'} }
		it "renders correctly" do	
			expect(subject).to render_template("users/userfollow")
		end
	end


end
