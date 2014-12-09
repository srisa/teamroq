require 'rails_helper'

describe TodoFollowersController do

  before(:each) do
    $redis.flushdb
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @todo = FactoryGirl.create(:todo, user_id: @user.id)
    @todo_list = @todo.todo_list
    sign_in @user
  end

  describe "PATCH create" do
    describe "template" do
      subject {patch :create, {todo_list_id: @todo_list.id, id: @todo.id, format: 'js'} }
      it "renders correctly" do
        expect(subject).to render_template("todos/follow")
      end
    end
    it "assigns followers count" do
      patch :create, {todo_list_id: @todo_list.id, id: @todo.id, format: 'js'} 
      expect(assigns(:followers_count)).to eq(1)
    end
  end

  describe "PATCH destroy" do
    describe "template" do
      subject {patch :destroy, {todo_list_id: @todo_list.id, id: @todo.id, format: 'js'} }
      it "renders correctly" do 
        expect(subject).to render_template("todos/follow")
      end
    end

    it "assigns followers count" do
      $redis.sadd @todo.followers_key, @user.id
      patch :destroy, {todo_list_id: @todo_list.id, id: @todo.id, format: 'js'} 
      expect(assigns(:followers_count)).to eq(0)
    end
  end

  describe "PATCH add_followers" do
     it "assigns followers count" do
      request.env["HTTP_REFERER"] = "/"
      patch :add_followers, {todo_list_id: @todo_list.id, id: @todo.id, followers_list: @user.slug}
      expect(assigns(:followers_count)).to eq(1)
    end

    it "redirects to back" do
      request.env["HTTP_REFERER"] = "/"
      patch :add_followers, {todo_list_id: @todo_list.id, id: @todo.id, followers_list: @user.slug}
      expect(response).to redirect_to("/")
    end

    describe "with invalid params" do
      it "redirects to back" do
        request.env["HTTP_REFERER"] = "/"
        patch :add_followers, {todo_list_id: @todo_list.id, id: @todo.id, followers_list: ""}
        expect(response).to redirect_to("/")
      end
    end
  end
end
