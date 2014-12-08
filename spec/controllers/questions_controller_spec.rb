require 'rails_helper'

describe QuestionsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question, topic_list: "topic")
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end

  def valid_attributes
    {"title" => "Test tile", "content" => "Question content",
      "topic_list" => "topic,test"
    }
  end

  describe "GET index" do
    it "assigns all questions as @questions" do  
      get :index
      expect(assigns(:tags)).to eq([ActsAsTaggableOn::Tag.last])
    end
  end

  describe "GET show" do
    it "assigns the requested question as @question" do
      get :show, {:id => @question.id}
      expect(assigns(:question)).to eq(@question)
    end
  end

  describe "GET new" do
    it "assigns a new question as @question" do
      get :new
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe "GET edit" do
    it "assigns the requested question as @question" do
      get :edit, {:id => @question.id}
      expect(assigns(:question)).to eq(@question)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, {:question =>valid_attributes}
        }.to change(Question, :count).by(1)
      end

      it "assigns a newly created question as @question" do
        post :create, {:question =>valid_attributes}
        expect(assigns(:question)).to be_a(Question)
        expect(assigns(:question)).to be_persisted
      end

      it "redirects to the created question" do
        post :create, {:question =>valid_attributes}
        expect(response).to redirect_to(question_path(Question.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        expect_any_instance_of(Question).to receive(:save).and_return(false)
        post :create, {:question => {  :title => "Sdsdsd", :content=> "sdsadfsfdfsaf"}}
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted 
        expect_any_instance_of(Question).to receive(:save).and_return(false)
        post :create, {:question => {content: "heloodsd"}}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      before(:each) do
          allow(controller).to receive(:track_question_activity).and_return(true)
        end

      it "updates the requested question" do    
        expect_any_instance_of(Question).to receive(:update_attributes).with({ "title" => "params" })
        patch :update, {:id => @question.id, :question => { "title" => "params" }}
      end

      it "assigns the requested question as @question" do
        patch :update, {:id => @question.id, :question => valid_attributes}
        expect(assigns(:question)).to eq(@question)
      end

      it "redirects to the question" do
        patch :update, {:id => @question.id, :question => valid_attributes}
        expect(response).to redirect_to(@question)
      end
    end

    describe "with invalid params" do
      it "assigns the question as @question" do    
        expect_any_instance_of(Question).to receive(:save).and_return(false)
        patch :update, {:id => @question.id, :question => { :title =>"" }}
        expect(assigns(:question)).to eq(@question)
      end

      it "re-renders the 'edit' template" do  
        expect_any_instance_of(Question).to receive(:save).and_return(false)
        patch :update, {:id => @question.id, :question => {name: "", content: "", topic_list: ""}}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question" do
      expect {
        delete :destroy, {:id => @question.id}
      }.to change(Question, :count).by(-1)
    end

    it "redirects to the questions list" do
      delete :destroy, {:id => @question.id}
      expect(response).to redirect_to(questions_url)
    end
  end

  describe "POST vote" do
    describe "UP Vote" do
      it "renders template" do
        post :vote, {id: @question.id, type: "up", format: 'js'}
        expect(response).to render_template("votes/vote")
      end

      it "calls add vote method" do
        expect_any_instance_of(Question).to receive(:add_vote).with(1,@user.id)
        post :vote, {id: @question.id, type: "up", format: 'js'}
      end
     end

    describe "DOWN Vote" do
      it "renders  template" do
        post :vote, {id: @question.id, type: "down", format: 'js'}
        expect(response).to render_template("votes/vote")
      end

      it "calls add vote method" do
        expect_any_instance_of(Question).to receive(:add_vote).with(-1,@user.id)
        post :vote, {id: @question.id, type: "down", format: 'js'}
      end
    end
  end

  describe "GET topic" do
    it "assigns variables" do
      get :topic, {tag: 'topic'}
      expect(assigns(:question_count)).to eq(1)
      expect(assigns(:followers_count)).to eq(0)
      expect(assigns(:questions)).to eq([@question])
    end
  end
end
