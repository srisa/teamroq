require 'rails_helper'

describe DiscussionFollowersController, :type => :controller do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    @discussion = FactoryGirl.create(:discussion, discussable_id: @project.id, discussable_type: "Project",user_id: @user.id)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end
  describe "PATCH follow" do
    it "assigns followers count" do
      patch :create, {project_id: @project.id, :id => @discussion.id, format: 'js'}
      expect(assigns(:followers_count)).to eq(1)
    end

    it "renders the template" do
      patch :create, {project_id: @project.id, :id => @discussion.id, format: 'js'}
      expect(response).to render_template("discussions/follow")
    end
  end

  describe "PATCH unfollow" do
    it "assigns followers count" do
      patch :create,{project_id: @project.id, :id => @discussion.id, format: 'js'}
      expect(assigns(:followers_count)).to eq(1)
      patch :destroy, {project_id: @project.id, :id => @discussion.id, format: 'js'}
      expect(assigns(:followers_count)).to eq(0)
    end

    it "renders the template" do
      patch :destroy, {project_id: @project.id, :id => @discussion.id, format: 'js'}
      expect(response).to render_template("discussions/follow")
    end
  end

  describe "PATCH add_followers" do
    it "assigns followers count" do
      request.env["HTTP_REFERER"] = "/"
      patch :add_followers, {project_id: @project.id, :id => @discussion.id, followers_list: @user.slug}
      expect(assigns(:followers_count)).to eq(1)
    end

    it "redirects to back" do
      request.env["HTTP_REFERER"] = "/"
      patch :add_followers, {project_id: @project.id, :id => @discussion.id, followers_list: @user.slug}
      expect(response).to redirect_to("/")
    end
  end
  
end
