require 'rails_helper'

describe QuestionFollowersController do

	before(:each) do
	$redis.flushdb
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question)
    sign_in @user
	end

	describe "PATCH create" do
		describe "template" do
			subject {patch :create, {id: @question.id, format: 'js'} }
			it "renders correctly" do
				expect(subject).to render_template("questions/follow")
			end
		end

		it "assigns followers count" do
			patch :create, {id: @question.id, format: 'js'}
			expect(assigns(:followers_count)).to eq(1)
		end
	end

	describe "PATCH destroy" do
		describe "template" do
			subject {patch :destroy, {id: @question.id, format: 'js'} }
			it "renders correctly" do	
				expect(subject).to render_template("questions/follow")
			end
		end
		it "assigns followers count" do
			$redis.sadd @question.followers_key, @user.id
			patch :destroy, {id: @question.id, format: 'js' }
			expect(assigns(:followers_count)).to eq(0)
		end
	end
end
