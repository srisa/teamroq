require 'rails_helper'
describe DiscussionsController do
  render_views
  before(:each) do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    @discussion = FactoryGirl.create(:discussion, discussable_id: @project.id, discussable_type: "Project",user_id: @user.id)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end

  let(:valid_attributes) { { content: "content", title: "content" } }


  describe "GET index" do
    it "assigns all discussions as @discussions" do
      @second_discussion = FactoryGirl.create(:discussion, discussable_id: @project.id, discussable_type: "Project", user_id: @user.id)
      get :index, {project_id: @project.id}
      expect(assigns(:discussions)).to eq([@second_discussion, @discussion])
    end

    it "discussions/filter/latest" do
      get :index, {project_id: @project.id, filter: "latest"}
      expect(assigns(:discussions)).to eq([@discussion])
    end

    it "discussions/filter/popular" do
      get :index, {project_id: @project.id, filter: "popular"}
      expect(assigns(:discussions)).to eq([@discussion])
    end

    it "discussions/filter/followed" do
      @discussion.followers.push @user.id
      @discussion.followers_will_change!
      @discussion.save
      @second_discussion = FactoryGirl.create(:discussion, discussable_id: @project.id, discussable_type: "Project",user_id: @user.id)
      get :index, {project_id: @project.id, filter: "followed"}
      expect(assigns(:discussions)).to eq([@discussion])
    end
    
    it "discussions/filter/created" do
      @second_user = FactoryGirl.create(:user)
      @second_discussion = FactoryGirl.create(:discussion, discussable_id: @project.id, discussable_type: "Project",user_id: @second_user.id)
      get :index, {project_id: @project.id, filter: "created"}
      expect(assigns(:discussions)).to eq([@discussion])
    end
  end

  describe "GET show" do
    it "assigns the requested discussion as @discussion" do
      get :show, {project_id: @project.id, :id => @discussion.id}
      expect(assigns(:discussion)).to eq(@discussion)
    end

    it "assigns new comment" do
      get :show, {project_id: @project.id, :id => @discussion.id}
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it "assigns watchers" do
      @discussion.followers.push @user.id
      @discussion.followers_will_change!
      @discussion.save
      get :show, {project_id: @project.id, :id => @discussion.id}
      expect(assigns(:watchers)).to eq([@user])
    end

  end

  describe "GET new" do
    it "assigns a new discussion as @discussion" do
      get :new, {project_id: @project.id}
      expect(assigns(:discussion)).to be_a_new(Discussion)
    end
  end

  describe "GET edit" do
    it "assigns the requested discussion as @discussion" do
      get :edit, {project_id: @project.id, :id => @discussion.id}
      expect(assigns(:discussion)).to eq(@discussion)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Discussion" do
        allow(controller).to receive(:track_discussion_activity_create).and_return(true)
        expect {
          post :create, {project_id: @project.id, :discussion => valid_attributes}
        }.to change(Discussion, :count).by(1)
      end

      it "creates a new Discussion and adds users" do
        allow(controller).to receive(:track_discussion_activity_create).and_return(true)
        expect {
          post :create, {project_id: @project.id, :discussion => valid_attributes, followers_list: "1,2"}
        }.to change(Discussion, :count).by(1)
      end

      it "assigns a newly created discussion as @discussion" do
        allow(controller).to receive(:track_discussion_activity_create).and_return(true)
        post :create, {project_id: @project.id, :discussion => valid_attributes}
        expect(assigns(:discussion)).to be_a(Discussion)
        expect(assigns(:discussion)).to be_persisted
      end

      it "redirects to the created discussion" do
        allow(controller).to receive(:track_discussion_activity_create).and_return(true)
        post :create, {project_id: @project.id, :discussion => valid_attributes}
        expect(response).to redirect_to([@project,Discussion.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved discussion as @discussion" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Discussion).to receive(:save).and_return(false)
        post :create, {project_id: @project.id, :discussion => { "content" => "" }}
        expect(assigns(:discussion)).to be_a_new(Discussion)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Discussion).to receive(:save).and_return(false)
        post :create, {project_id: @project.id, :discussion => { "content" => "" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested discussion" do
        allow(controller).to receive(:track_discussion_activity_create).and_return(true)
        expect_any_instance_of(Discussion).to receive(:update_attributes).with({ "content" => "MyText" })
        patch :update, {project_id: @project.id, :id => @discussion.id, :discussion => { "content" => "MyText" }}
      end

      it "assigns the requested discussion as @discussion" do
        allow(controller).to receive(:track_discussion_activity_create).and_return(true)
        patch :update, {project_id: @project.id, :id => @discussion.id, :discussion => valid_attributes}
        expect(assigns(:discussion)).to eq(@discussion)
      end

      it "redirects to the discussion" do
        allow(controller).to receive(:track_discussion_activity_create).and_return(true)
        patch :update, {project_id: @project.id, :id => @discussion.id, :discussion => valid_attributes}
        expect(response).to redirect_to([@project, @discussion])
      end
    end

    describe "with invalid params" do
      it "assigns the discussion as @discussion" do
        expect_any_instance_of(Discussion).to receive(:save).and_return(false)
        patch :update, {project_id: @project.id, :id => @discussion.id, :discussion => { content: "" }}
        expect(assigns(:discussion)).to eq(@discussion)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(Discussion).to receive(:save).and_return(false)
        patch :update, {project_id: @project.id, :id => @discussion.id, :discussion => { title: "" }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested discussion" do
      expect {
        delete :destroy, {project_id: @project.id, :id => @discussion.id}
      }.to change(Discussion, :count).by(-1)
    end

    it "redirects to the discussions list" do
      delete :destroy, {project_id: @project.id, :id => @discussion.id}
      expect(response).to redirect_to(project_discussions_url(@project))
    end
  end

  

  describe "GET searchuser" do
    it "searches the user" do
      @user = FactoryGirl.create(:user, name: "Tim")
      @user.projects.push @project
      get :searchuser, {project_id: @project.id, name: "tim", format: "json"}
      expect(response.body).to match /tim/i
    end
  end
end
