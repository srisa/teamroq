require 'rails_helper'

describe PostsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @group = FactoryGirl.create(:group)
    @post = FactoryGirl.create(:post, postable_id: @group.id, postable_type: "Group")
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end

  let(:valid_attributes) { { content: "content"} }

  describe "GET index" do
    it "assigns all posts as @posts" do
      get :index, {group_id: @group.id}
      expect(assigns(:posts)).to eq([@post])
    end
  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      get :show, {group_id: @group.id, :id => @post.id}
      expect(assigns(:post)).to eq(@post)
    end
  end

  describe "GET new" do
    it "assigns a new post as @post" do
      get :new, {group_id: @group.id }
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "GET edit" do
    it "assigns the requested post as @post" do
      get :edit, {group_id: @group.id, :id => @post.id}
      expect(assigns(:post)).to eq(@post)
    end
  end

  describe "POST create" do

    before(:each) do
      request.env["HTTP_REFERER"] = "/"
    end

    describe "with valid params" do
      it "creates a new Post" do
        expect {
          post :create, {group_id: @group.id, :post => valid_attributes}
        }.to change(Post, :count).by(1)
      end

      it "assigns a newly created post as @post" do
        post :create, {group_id: @group.id, :post => valid_attributes}
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
      end

      it "redirects to the created post" do
        post :create, {group_id: @group.id, :post => valid_attributes}
        expect(response).to redirect_to("/")
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        # Trigger the behavior that occurs when invalid params are submitted
       expect_any_instance_of(Post).to receive(:save).and_return(false)
        post :create, {group_id: @group.id, :post => { content: "" }}
        expect(assigns(:post)).to be_a_new(Post)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
       expect_any_instance_of(Post).to receive(:save).and_return(false)
        post :create, {group_id: @group.id, :post => { content: "" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested post" do
        allow(controller).to receive(:track_activity).and_return(true)
        expect_any_instance_of(Post).to receive(:update_attributes).with({ "content" => "MyString" })
        patch :update, {group_id: @group.id, :id => @post.id, :post => { "content" => "MyString" }}
      end

      it "assigns the requested post as @post" do
         allow(controller).to receive(:track_activity).and_return(true)
        patch :update, {group_id: @group.id, :id => @post.id, :post => valid_attributes}
        expect(assigns(:post)).to eq(@post)
      end

      it "redirects to the post" do
         allow(controller).to receive(:track_activity).and_return(true)
        patch :update, {group_id: @group.id, :id => @post.id, :post => valid_attributes}
        expect(response).to redirect_to([@group,@post])
      end
    end

    describe "with invalid params" do
      it "assigns the post as @post" do
        expect_any_instance_of(Post).to receive(:save).and_return(false)
        patch :update, {group_id: @group.id, :id => @post.id, :post => { content: "" }}
        expect(assigns(:post)).to eq(@post)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(Post).to receive(:save).and_return(false)
        patch :update, {group_id: @group.id, :id => @post.id, :post => { content: "" }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested post" do
      request.env["HTTP_REFERER"] = "/test"
      expect {
          delete :destroy, {group_id: @group.id, :id => @post.id}
      }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      request.env["HTTP_REFERER"] = "/test"
      delete :destroy, {group_id: @group.id, :id => @post.id}
      expect(response).to redirect_to("/test")
    end
  end

end
