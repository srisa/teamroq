require 'rails_helper'

describe AnnouncementsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @announcement = FactoryGirl.create(:announcement)
    @group = @announcement.announcable
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end
  
  let(:valid_attributes) { { content: "Announcement" } }

  describe "GET index" do
    it "assigns all announcements as @announcements" do
      get :index, {group_id: @group.id}
      expect(assigns(:announcements)).to eq([@announcement])
    end
  end

  describe "GET show" do
    it "assigns the requested announcement as @announcement" do
      get :show, {group_id: @group.id, :id => @announcement.id}
      expect(assigns(:announcement)).to eq(@announcement)
    end
  end

  describe "GET new" do
    it "assigns a new announcement as @announcement" do
      get :new, {group_id: @group.id}
      expect(assigns(:announcement)).to be_a_new(Announcement)
    end
  end

  describe "GET edit" do
    it "assigns the requested announcement as @announcement" do
      get :edit, {group_id: @group.id,:id => @announcement.id}
      expect(assigns(:announcement)).to eq(@announcement)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Announcement" do
        expect {
          post :create, {group_id: @group.id, :announcement => valid_attributes}
        }.to change(Announcement, :count).by(1)
      end

      it "assigns a newly created announcement as @announcement" do
        post :create, {group_id: @group.id,:announcement => valid_attributes}
        expect(assigns(:announcement)).to be_a(Announcement)
        expect(assigns(:announcement)).to be_persisted
      end

      it "redirects to the announcements" do
        post :create, {group_id: @group.id, :announcement => valid_attributes}
        expect(response).to redirect_to(group_announcements_path(@group))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved announcement as @announcement" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Announcement).to receive(:save).and_return(false)
        post :create, {group_id: @group.id, :announcement => { content: "" }}
        expect(assigns(:announcement)).to be_a_new(Announcement)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Announcement).to receive(:save).and_return(false)
        post :create, {group_id: @group.id, :announcement => { content: ""  }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested announcement" do
        expect_any_instance_of(Announcement).to receive(:update_attributes).with({ content: "hello" })
        patch :update, {group_id: @group.id, :id => @announcement.to_param, :announcement => { content: "hello" }}
      end

      it "assigns the requested announcement as @announcement" do
        patch :update, {group_id: @group.id, :id => @announcement.to_param, :announcement => valid_attributes}
        expect(assigns(:announcement)).to eq(@announcement)
      end

      it "redirects to the announcement" do
        patch :update, {group_id: @group.id, :id => @announcement.to_param, :announcement => valid_attributes}
        expect(response).to redirect_to([@group,@announcement])
      end
    end

    describe "with invalid params" do
      it "assigns the announcement as @announcement" do

        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Announcement).to receive(:save).and_return(false)
        patch :update, {group_id: @group.id, :id => @announcement.to_param, :announcement => { content: ""  }}
        expect(assigns(:announcement)).to eq(@announcement)
      end

      it "re-renders the 'edit' template" do

        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Announcement).to receive(:save).and_return(false)
        patch :update, {group_id: @group.id, :id => @announcement.to_param, :announcement => { content: ""}}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      request.env["HTTP_REFERER"] = "/"
    end

    it "destroys the requested announcement" do
      expect {
        delete :destroy, {group_id: @group.id, :id => @announcement.to_param}
      }.to change(Announcement, :count).by(-1)
    end

    it "redirects to the announcements list" do
      delete :destroy, {group_id: @group.id, :id => @announcement.to_param}
      expect(response).to redirect_to("/")
    end
  end

end
