require 'rails_helper'

describe TodosController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @todo = FactoryGirl.create(:todo)
    @todo_list = @todo.todo_list
    sign_in @user
  end

  let(:valid_attributes) { { name: "todo", details: "details", target_date: 2.days.from_now } }

  describe "GET index" do
    it "assigns all todos as @todos" do
      get :index, {todo_list_id: @todo_list.id}
      expect(assigns(:todos)).to eq([@todo])
    end
  end

  describe "GET show" do
    it "assigns the requested todo as @todo" do
      get :show, {todo_list_id: @todo_list.id, :id => @todo.id}
      expect(assigns(:todo)).to eq(@todo)
    end
  end

  describe "GET new" do
    it "assigns a new todo as @todo" do
      get :new, {todo_list_id: @todo_list.id}
      expect(assigns(:todo)).to be_a_new(Todo)
    end
  end

  describe "GET edit" do
    it "assigns the requested todo as @todo" do
      get :edit, {todo_list_id: @todo_list.id, :id => @todo.id}
      expect(assigns(:todo)).to eq(@todo)
    end
  end

  describe "POST create" do
    before(:each) do
      with_versioning do
        PaperTrail.whodunnit = @user
      end
    end

    describe "with valid params" do
      it "creates a new Todo" do
        expect {
          post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
        }.to change(Todo, :count).by(1)
      end

      it "assigns a newly created todo as @todo" do
        post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
        expect(assigns(:todo)).to be_a(Todo)
        expect(assigns(:todo)).to be_persisted
      end

      it "redirects to the created todo" do
        post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
        expect(response).to redirect_to([@todo_list,Todo.last])
      end

      with_versioning do
        it "creates a version" do
          expect{
            post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
          }.to change(PaperTrail::Version, :count).by(1)
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved todo as @todo" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Todo).to receive(:save).and_return(false)
        post :create, {todo_list_id: @todo_list.id, :todo => {name: "", details: "", target_date: ""  }}
        expect(assigns(:todo)).to be_a_new(Todo)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Todo).to receive(:save).and_return(false)
        post :create, {todo_list_id: @todo_list.id, :todo => {name: "", details: "", target_date: ""  }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested todo" do
        allow(controller).to receive(:track_todo_activity).and_return(true)
        expect_any_instance_of(Todo).to receive(:update_attributes).with({ name: "newtasky"})
        patch :update, {todo_list_id: @todo_list.id, :id => @todo.id, :todo => { name: "newtasky" }}
      end

      it "assigns the requested todo as @todo" do
        allow(controller).to receive(:track_todo_activity).and_return(true)
        patch :update, {todo_list_id: @todo_list.id, :id => @todo.id, :todo => valid_attributes}
        expect(assigns(:todo)).to eq(@todo)
      end

      it "redirects to the todo" do
        allow(controller).to receive(:track_todo_activity).and_return(true)
        patch :update, {todo_list_id: @todo_list.id, :id => @todo.id, :todo => valid_attributes}
        expect(response).to redirect_to([@todo_list, @todo])
      end

      with_versioning do
        it "creates a version" do
          expect{
            post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
          }.to change(PaperTrail::Version, :count).by(1)
        end
      end
    end

    describe "with invalid params" do
      it "assigns the todo as @todo" do
        expect_any_instance_of(Todo).to receive(:save).and_return(false)
        patch :update, {todo_list_id: @todo_list.id, :id => @todo.id, :todo => {name: "", details: "", target_date: ""  }}
        expect(assigns(:todo)).to eq(@todo)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(Todo).to receive(:save).and_return(false)
        patch :update, {todo_list_id: @todo_list.id, :id => @todo.id, :todo => {name: "", details: "", target_date: ""  }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested todo by others" do
      expect {
        delete :destroy, {todo_list_id: @todo_list.id, :id => @todo.id}
      }.to change(Todo, :count).by(0)
    end

    it "destroys the requested todo by self" do
      @todo = FactoryGirl.create(:todo, user_id: @user.id)
      @todo_list = @todo.todo_list
      expect {
        delete :destroy, {todo_list_id: @todo_list.id, :id => @todo.id}
      }.to change(Todo, :count).by(-1)
    end

    it "redirects to the todos list" do
      delete :destroy, {todo_list_id: @todo_list.id, :id => @todo.id}
      expect(response).to redirect_to("/tasks")
    end
  end

  describe "PATCH change_date" do
    it "updates the requested todo" do
      allow(controller).to receive(:track_todo_activity_change_date).and_return(true)
      expect_any_instance_of(Todo).to receive(:update_attributes).and_return(true)
      patch :change_date, {todo_list_id: @todo_list.id, :id => @todo.id, todo: {target_date: 3.days.from_now}}
    end

    it "redirects to todo" do
      patch :change_date, {todo_list_id: @todo_list.id, :id => @todo.id, todo: {target_date: 3.days.from_now}}
      expect(response).to redirect_to([@todo_list, @todo])
    end

    with_versioning do
      it "creates a version" do
        expect{
          post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
        }.to change(PaperTrail::Version, :count).by(1)
      end
    end

    describe "with invalid params" do

      it "will not save the todo" do
        allow(controller).to receive(:track_todo_activity_change_date).and_return(true)
        expect_any_instance_of(Todo).to receive(:update_attributes).and_return(false)
        patch :change_date, {todo_list_id: @todo_list.id, :id => @todo.id, todo: {target_date: ""}}
      end

      it "redirects to edit" do
        patch :change_date, {todo_list_id: @todo_list.id, :id => @todo.id, todo: {target_date: ""}}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "PATCH change_user" do
    it "updates the requested todo" do
      allow(controller).to receive(:track_todo_activity_change_user).and_return(true)
      expect_any_instance_of(Todo).to receive(:update_attributes).and_return(true)
      patch :change_user, {todo_list_id: @todo_list.id, :id => @todo.id, todo: {user_id: 2}}
    end

    it "redirects to todo" do
      patch :change_user, {todo_list_id: @todo_list.id, :id => @todo.id, todo: {user_id: 2}}
      expect(response).to redirect_to([@todo_list, @todo])
    end

    with_versioning do
      it "creates a version" do
        expect{
          post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
        }.to change(PaperTrail::Version, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "will not save the todo" do
        allow(controller).to receive(:track_todo_activity_change_user).and_return(true)
        expect_any_instance_of(Todo).to receive(:update_attributes).and_return(false)
        patch :change_user, {todo_list_id: @todo_list.id, :id => @todo.id, todo: {user_id: ""}}
      end

      it "redirects to edit" do
        patch :change_user, {todo_list_id: @todo_list.id, :id => @todo.id, todo: {user_id: ""}}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "PATCH close" do
    before(:each) do
      request.env["HTTP_REFERER"] = "/"
    end

    it "closes the todo" do
      patch :close, {todo_list_id: @todo_list.id, :id => @todo.id}
      @todo.reload
      expect(@todo.closed?).to eq(true)
    end

    it "redirects to back" do
      patch :close, {todo_list_id: @todo_list.id, :id => @todo.id}
      expect(response).to redirect_to("/")
    end

    with_versioning do
      it "creates a version" do
        expect{
          post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
        }.to change(PaperTrail::Version, :count).by(1)
      end
    end
  end

  describe "PATCH reopen" do
    before(:each) do
      request.env["HTTP_REFERER"] = "/"
    end

    it "reopen the todo" do
      patch :reopen, {todo_list_id: @todo_list.id, :id => @todo.id}
      @todo.reload
      expect(@todo.open?).to eq(true)
    end

    it "redirects to back" do
      patch :reopen, {todo_list_id: @todo_list.id, :id => @todo.id}
      expect(response).to redirect_to("/")
    end

    with_versioning do
      it "creates a version" do
        expect{
          post :create, {todo_list_id: @todo_list.id, :todo => valid_attributes}
        }.to change(PaperTrail::Version, :count).by(1)
      end
    end
  end

  describe "PATCH state history" do
    it "assigns versions" do
      @todo.close
      patch :state_history, {todo_list_id: @todo_list.id, :id => @todo.id, format: 'js'}
      expect(assigns(:states)).to eq(@todo.versions)
    end
  end
end
