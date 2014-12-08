require 'rails_helper'

describe AnswersController do
  render_views
  before(:each) do
    @user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question)
    @answer = FactoryGirl.create(:answer, question_id: @question.id)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end

  let(:valid_attributes){
    { content: "content", question_id: "1"}
  }

  describe "GET index" do
    it "assigns all answers as @answers" do
      get :index, {question_id: @question.id}
      expect(assigns(:answers)).to eq([@answer])
    end
  end

  describe "GET show" do
    it "assigns the requested answer as @answer" do
      get :show, {question_id: @question.id, id: @answer.id}
      expect(assigns(:answer)).to eq(@answer)
    end
  end

  describe "GET new" do
    it "assigns a new answer as @answer" do
      get :new, {question_id: @question.id}
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe "GET edit" do
    it "assigns the requested answer as @answer" do
      get :edit, {question_id: @question.id,id: @answer.id}
      expect(assigns(:answer)).to eq(@answer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Answer" do
        expect {
          post :create, {question_id: @question.id, answer: valid_attributes}
        }.to change(Answer, :count).by(1)
      end

      it "assigns a newly created answer as @answer" do
        post :create, {question_id: @question.id, answer: valid_attributes}
        expect(assigns(:answer)).to be_a(Answer)
        expect(assigns(:answer)).to be_persisted
      end

      it "redirects to the question" do
        post :create, {question_id: @question.id, answer: valid_attributes}
        expect(response).to redirect_to(@question)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved answer as @answer" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Answer).to receive(:save).and_return(false)
        post :create, {question_id: @question.id, answer: { "content" => "" }}
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Answer).to receive(:save).and_return(false)
        post :create, {question_id: @question.id, answer: { "content" => "" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested answer" do
        allow(controller).to receive(:track_answer_activity).and_return(true)
        expect_any_instance_of(Answer).to receive(:update_attributes).with({ "content" => "MyString" })
        patch :update, {question_id: @question.id, id: @answer.id, answer: { "content" => "MyString" }}
      end

      it "assigns the requested answer as @answer" do
        allow(controller).to receive(:track_answer_activity).and_return(true)
        patch :update, {question_id: @question.id, id: @answer.id, answer: valid_attributes}
        expect(assigns(:answer)).to eq(@answer)
      end

      it "redirects to the answer" do
        allow(controller).to receive(:track_answer_activity).and_return(true)
        patch :update, {question_id: @question.id, id: @answer.id, answer: valid_attributes}
        expect(response).to redirect_to([@question, @answer])
      end
    end

    describe "with invalid params" do
      it "assigns the answer as @answer" do
        expect_any_instance_of(Answer).to receive(:save).and_return(false)
        patch :update, {question_id: @question.id, id: @answer.id, answer: { "content" => "" }}
        expect(assigns(:answer)).to eq(@answer)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(Answer).to receive(:save).and_return(false)
        patch :update, {question_id: @question.id, id: @answer.id, answer: { "content" => "" }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested answer" do
      expect {
        delete :destroy, {question_id: @question.id, id: @answer.id}
      }.to change(Answer, :count).by(-1)
    end

    it "redirects to the answers list" do
      delete :destroy, {question_id: @question.id, id: @answer.id}
      expect(response).to redirect_to(@question)
    end
  end

  describe "POST vote" do
    describe "UP Vote" do
      it "renders template" do
        post :vote, {id: @answer.id, type: "up", format: 'js'}
        expect(response).to render_template("votes/vote")
      end

      it "calls add vote method" do
        expect_any_instance_of(Answer).to receive(:add_vote).with(1,@user.id)
        post :vote, {id: @answer.id, type: "up", format: 'js'}
      end
     end

    describe "DOWN Vote" do
      it "renders  template" do
        post :vote, {id: @answer.id, type: "down", format: 'js'}
        expect(response).to render_template("votes/vote")
      end

      it "calls add vote method" do
        expect_any_instance_of(Answer).to receive(:add_vote).with(-1,@user.id)
        post :vote, {id: @answer.id, type: "down", format: 'js'}
      end
    end
  end

  describe "POST markanswer" do
    before(:each) do
      allow(controller).to receive(:track_answer_activity).and_return(true)
    end

    it "marks the answer" do     
      expect_any_instance_of(Answer).to receive(:save).and_return(true)
      post :markanswer, {id: @answer.id, type: "mark", format: 'js'}
    end

    it "will not mark with invalid params" do
      expect_any_instance_of(Answer).to receive(:save).and_return(true)
      post :markanswer, {id: @answer.id, type: "dont", format: 'js'}
    end

    it "renders the template" do
      post :markanswer, {id: @answer.id, type: "dont", format: 'js'}
      expect(response).to render_template("answers/markanswer")
    end
  end

end
