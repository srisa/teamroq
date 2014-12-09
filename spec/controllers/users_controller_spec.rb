require 'rails_helper'

describe UsersController do

  before(:each) do
    $redis.flushdb
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @other_user = FactoryGirl.create(:user)
    sign_in @user
  end

  let(:valid_attributes){{name: "joe", password: "foobar123", password_confirmation: "foobar123", email: "a@email.org"}}

  describe "GET index" do
    it "assigns all users as @users" do
      get :index
      expect(assigns(:users)).to eq([@user,@other_user])
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      get :show, {:id => @user.id}
      expect(assigns(:user)).to eq(@user)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      get :edit, {:id => @user.id}
      expect(assigns(:user)).to eq(@user)
    end

    it "doesnt show other users edit page" do 
      expect{
        get :edit, {:id => @other_user.id} 
        }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested user" do
        expect_any_instance_of(User).to receive(:update_attributes).with({ name: "tim" })
        patch :update, {:id => @user.id, :user => { name: "tim" }}
      end

       it "will not update other users" do 
         expect{ 
          patch :update, {:id => @other_user.id, :user => { name: "tim" }} 
          }.to raise_error(ActionController::RoutingError)
      end

      it "assigns the requested user as @user" do
        patch :update, {:id => @user.id, :user => valid_attributes}
        expect(assigns(:user)).to eq(@user)
      end

      it "redirects to the user" do
        patch :update, {:id => @user.id, :user => valid_attributes}
        expect(response).to redirect_to(@user)
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        expect_any_instance_of(User).to receive(:save).and_return(false)
        patch :update, {:id => @user.id, :user => { name: "", email: "", password: "", password_confirmation: "" }}
        expect(assigns(:user)).to eq(@user)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(User).to receive(:save).and_return(false)
        patch :update, {:id => @user.id, :user => { name: "", email: "", password: "", password_confirmation: "" }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      expect {
        delete :destroy, {:id => @user.id}
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      delete :destroy, {:id => @user.id}
      expect(response).to redirect_to(users_url)
    end
  end

  describe "GET tasks" do
    it "assigns tasks" do
      @todo = FactoryGirl.create(:todo, user_id: @user.id)
      @todo2 = FactoryGirl.create(:todo)
      get :tasks
      expect(assigns(:tasks)).to eq([@todo])
    end
  end

  describe "GET tasks/closed" do
    it "assigns tasks" do
      @todo = FactoryGirl.create(:todo, user_id: @user.id)
      @todo2 = FactoryGirl.create(:todo)
      @todo.close
      get :closed
      expect(assigns(:tasks)).to eq([@todo])
    end
  end

  describe "GET tasks/created" do
    before(:each) do
      with_versioning do
        PaperTrail.whodunnit = @user
      end
    end

    with_versioning do
      it "assigns tasks" do
        @todo = FactoryGirl.build(:todo, user_id: @user.id)
        @todo.paper_trail_event = 'created'
        @todo.save
        @todo2 = FactoryGirl.build(:todo)
        @todo2.save
        get :created_open_tasks
        expect(assigns(:todos)).to eq([@todo])
      end
    end
  end

  describe "GET tasks/created/closed" do
    before(:each) do
      with_versioning do
        PaperTrail.whodunnit = @user
      end
    end

    with_versioning do
      it "assigns tasks" do
        @todo = FactoryGirl.build(:todo, user_id: @user.id)
        @todo2 = FactoryGirl.build(:todo, user_id: @user.id)
        @todo.paper_trail_event = 'created'
        @todo.save
        @todo2.save
        @todo.paper_trail_event = 'closed'
        @todo.close
        get :created_closed_tasks
        expect(assigns(:todos)).to eq([@todo])
      end
    end
  end

  describe "GET /documents" do
    it "assigns documents" do
      @document = FactoryGirl.create(:document, user_id: @user.id)
      @document2 = FactoryGirl.create(:document)
      get :documents
      expect(assigns(:documents)).to eq([@document])
    end
  end

  describe "GET /myquestions" do
    it "assigns for myquestions/created" do
      @question = FactoryGirl.create(:question, user_id: @user.id)
      @question2 = FactoryGirl.create(:question)
      get :myquestions, {filter: 'created'}
      expect(assigns(:questions)).to eq([@question])
    end

    it "assigns for myquestions/following" do
      @questions = FactoryGirl.create_list(:question, 3)
      $redis.sadd @questions[0].followers_key, @user.id
      $redis.sadd @user.questions_following_key, @questions[0].id
      get :myquestions, {filter: 'following'}
      expect(assigns(:questions)).to eq([@questions[0]])
    end
  end

  describe "GET /mytopics" do
    before(:each) do
      @question = FactoryGirl.create(:question, topic_list: "hello")
      @question2 = FactoryGirl.create(:question, topic_list: "hello")
    end

    it "assigns for mytopics" do
      get :mytopics
      expect(assigns(:tags)).to eq([ActsAsTaggableOn::Tag.last])
    end

    it "assigns for mytopics/following" do
      @topic = ActsAsTaggableOn::Tag.where(name: "hello").first
      $redis.sadd @topic.followers_key, @user.id
      $redis.sadd @user.topics_following_key, @topic.id
      get :mytopics, {filter: "following"}
      expect(assigns(:tags)).to eq([@topic])
    end
  end
end
