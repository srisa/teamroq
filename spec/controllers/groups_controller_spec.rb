require 'rails_helper'

describe GroupsController do

  before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      @group = FactoryGirl.create(:group)
      FactoryGirl.create(:group_role, user_id: @user.id, group_id: @group.id)
      sign_in @user
  end

  let(:valid_attributes){
      { "name" => "group" }
    }

  describe "GET index" do
    it "assigns all groups as @groups" do
      @second_group = FactoryGirl.create(:group)
      get :index
      expect(assigns(:groups)).to eq([@group])
    end
  end

  describe "GET show" do
    it "assigns the requested group as @group" do
      get :show, {:id => @group.id}
      expect(assigns(:group)).to eq(@group)
    end
  end

  describe "GET new" do
    it "assigns a new group as @group" do
      get :new, {}
      expect(assigns(:group)).to be_a_new(Group)
    end
  end

  describe "GET edit" do
    it "assigns the requested group as @group" do
      group = Group.create! valid_attributes
      get :edit, {:id => @group.id}
      expect(assigns(:group)).to eq(@group)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Group" do
         allow(controller).to receive(:add_users_to_group).and_return(true)
        expect {
          post :create, {:group => valid_attributes}
        }.to change(Group, :count).by(1)
      end

      it "assigns a newly created group as @group" do
        allow(controller).to receive(:add_users_to_group).and_return(true)
        post :create, {:group => valid_attributes}
        expect(assigns(:group)).to be_a(Group)
        expect(assigns(:group)).to be_persisted
      end

      it "redirects to the created group" do
        allow(controller).to receive(:add_users_to_group).and_return(true)
        post :create, {:group => valid_attributes}
        expect(response).to redirect_to(Group.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved group as @group" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Group).to receive(:save).and_return(false)
        post :create, {:group => { name: "" }}
        expect(assigns(:group)).to be_a_new(Group)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Group).to receive(:save).and_return(false)
        post :create, {:group => { name: "" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested group" do
        expect_any_instance_of(Group).to receive(:update_attributes).with({ "name" => "MyString" })
        patch :update, {:id => @group.id, :group => { "name" => "MyString" }}
      end

      it "assigns the requested group as @group" do
        patch :update, {:id => @group.id, :group => valid_attributes}
        expect(assigns(:group)).to eq(@group)
      end

      it "redirects to the group" do
        patch :update, {:id => @group.id, :group => valid_attributes}
        expect(response).to redirect_to(@group)
      end
    end

    describe "with invalid params" do
      it "assigns the group as @group" do
        expect_any_instance_of(Group).to receive(:save).and_return(false)
        patch :update, {:id => @group.id, :group => { name: "" }}
        expect(assigns(:group)).to eq(@group)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(Group).to receive(:save).and_return(false)
        patch :update, {:id => @group.id, :group => { name: "" }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested group as admin" do
      @user.add_role :manager, @group
      expect {
        delete :destroy, {:id => @group.id}
      }.to change(Group, :count).by(-1)
    end

    it "destroys the requested group as other" do
      expect {
        delete :destroy, {:id => @group.id}
      }.to change(Group, :count).by(0)
    end

    it "redirects to the groups list" do
      delete :destroy, {:id => @group.id}
      expect(response).to redirect_to(groups_url)
    end
  end

  describe "POST add_users" do
    before(:each) do
        request.env["HTTP_REFERER"] = "/"
      end

    describe "success case" do    
      it "redirects to back" do
        post :add_users, {group_id: @group.id, user_list: @user.slug}
        expect(response).to redirect_to("/")
      end

      it "creates a group role" do
        @group = FactoryGirl.create(:group)
        expect {
          post :add_users, {group_id: @group.id, user_list: @user.slug}
        }.to change(GroupRole, :count).by(1)
      end
    end

    describe "failure case" do
      it "redirects to back with out adding" do
        post :add_users, {group_id: @group.id, user_list: ""}
        expect(response).to redirect_to("/")
      end

      it "will not create a group role when it is already present" do
        expect {
          post :add_users, {group_id: @group.id, user_list: @user.slug}
        }.to change(GroupRole, :count).by(0)
      end
    end
  end

  describe "GET users" do
    it "assigns the users" do
      get :users, {id: @group.id}
      expect(assigns(:users)).to eq([@user])
    end
  end

  describe "GET documents" do
    before(:each) do
      @document = FactoryGirl.create(:document)
      @second_document = FactoryGirl.create(:document)  
      @group.documents.push @document
      @group.documents.push @second_document
    end

    it "assigns document as new" do
      get :documents, {id: @group.id}
      expect(assigns(:document)).to be_a_new(Document)
    end

    it "assigns documents" do    
      get :documents, {id: @group.id}
      expect(assigns(:documents)).to eq([@second_document, @document])

    end

    it "assigns documents for documents/today" do
      @second_document.update_attributes(updated_at: 2.days.ago)
      get :documents, {id: @group.id, filter: "today"}
      expect(assigns(:documents)).to eq([@document])
      expect(assigns(:document)).to be_a_new(Document)
    end

    it "assigns documents for documents/popular" do
      @second_document.update_attributes(updated_at: 2.days.ago)
      get :documents, {id: @group.id, filter: "popular"}
      expect(assigns(:documents)).to eq([@second_document, @document])
      expect(assigns(:document)).to be_a_new(Document)
    end

    it "assigns documents for documents/byme" do
      @second_document.update_attributes(user_id: @user.id)
      get :documents, {id: @group.id, filter: "byme"}
      expect(assigns(:documents)).to eq([@second_document])
      expect(assigns(:document)).to be_a_new(Document)
    end

  end

end
