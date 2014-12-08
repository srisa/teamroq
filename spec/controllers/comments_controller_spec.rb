require 'rails_helper'

describe CommentsController do
  render_views
	before(:each) do
	    @user = FactoryGirl.create(:user)
	    @comment = FactoryGirl.create(:comment)
	    @question = @comment.commentable
	    @request.env["devise.mapping"] = Devise.mappings[:user]
	    sign_in @user
  	end

  let(:valid_attributes) { { content: "comment" } }

  describe "GET index" do
    it "assigns all comments as @comments" do
      get :index, {question_id: @question.id}
      expect(assigns(:comments)).to eq([@comment])
    end
  end

  describe "GET new" do
    it "assigns a new comment as @comment" do
      get :new, {question_id: @question.id}
      expect(assigns(:comment)).to be_a_new(Comment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new comment" do
        request.env["HTTP_REFERER"] = "/"
      	allow(controller).to receive(:track_comment_activity_create).and_return(true)
        expect {
          post :create, {question_id: @question.id, comment: valid_attributes}
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        request.env["HTTP_REFERER"] = "/"
      	allow(controller).to receive(:track_comment_activity_create).and_return(true)
        post :create, {question_id: @question.id, comment: valid_attributes}
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it "redirects to the question" do
      	allow(controller).to receive(:track_comment_activity_create).and_return(true)
      	 request.env["HTTP_REFERER"] = "/"
        post :create, {question_id: @question.id, comment: valid_attributes}
        expect(response).to redirect_to("/")
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Comment).to receive(:save).and_return(false)
        post :create, {question_id: @question.id, comment: { "content" => "" }}
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Comment).to receive(:save).and_return(false)
        post :create, {question_id: @question.id, comment: { "content" => "" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "POST activity_comment" do
    before(:each) do
      @activity = FactoryGirl.create(:activity)
    end

    describe "with valid params" do
      it "creates a new comment" do
        request.env["HTTP_REFERER"] = "/"
        allow(controller).to receive(:track_comment_activity_create).and_return(true)
        expect {
          post :activity_comment, {activity_id: @activity.id, question_id: @question.id, comment: valid_attributes}
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        request.env["HTTP_REFERER"] = "/"
        allow(controller).to receive(:track_comment_activity_create).and_return(true)
        post :activity_comment, {activity_id: @activity.id, question_id: @question.id, comment: valid_attributes}
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it "redirects to the question" do
        allow(controller).to receive(:track_comment_activity_create).and_return(true)
         request.env["HTTP_REFERER"] = "/"
        post :activity_comment, {activity_id: @activity.id, question_id: @question.id, comment: valid_attributes}
        expect(response).to redirect_to("/")
      end

      it "renders the template" do
        allow(controller).to receive(:track_comment_activity_create).and_return(true)
        request.env["HTTP_REFERER"] = "/"
        post :activity_comment, {activity_id: @activity.id, question_id: @question.id, comment: valid_attributes, format: 'js'}
        expect(response).to render_template("comments/activity_comment")
      end
    end

    describe "with invalid params" do
    end
  end

  describe "GET activitycomments" do
    before(:each) do
      @activity = FactoryGirl.create(:activity)
    end

    it "assigns commentable and activity" do
      post :activitycomments, {activity_id: @activity.id, question_id: @question.id}
      expect(assigns(:commentable)).to eq(@question)
      expect(assigns(:activity)).to eq(@activity)
    end

    it "renders the template" do
      post :activitycomments, {activity_id: @activity.id, question_id: @question.id, format: 'js'}
      expect(response).to render_template("comments/activitycomments")
    end
  end

  describe "GET showcomment" do
    it "assigns comments" do
      get :showcomment, {question_id: @question.id, format: 'js'}
      expect(assigns(:comments)).to eq([@comment])
    end

    it "render the template" do
      get :showcomment, {question_id: @question.id, format: 'js'}
      expect(response).to render_template("comments/showcomment")
    end
  end
end
