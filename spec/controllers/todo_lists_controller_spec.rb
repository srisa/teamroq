require 'rails_helper'
describe TodoListsController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    @user.projects.push @project
    @todo_list = FactoryGirl.create(:todo_list, project_id: @project.id)
    sign_in @user
  end

  let(:valid_attributes) { { name: "list" } }

  describe "GET index" do
    it "assigns all todo_lists as @todo_lists" do
      get :index, {project_id: @project.id}
      expect(assigns(:todo_lists)).to eq([@todo_list])
    end
  end

  describe "GET show" do
    it "assigns the requested todo_list as @todo_list" do
      todo_list = TodoList.create! valid_attributes
      get :show, {project_id: @project.id, :id => @todo_list.id}
      expect(assigns(:todo_list)).to eq(@todo_list)
    end
  end

  describe "GET new" do
    it "assigns a new todo_list as @todo_list" do
      get :new, {project_id: @project.id }
      expect(assigns(:todo_list)).to be_a_new(TodoList)
    end
  end

  describe "GET edit" do
    it "assigns the requested todo_list as @todo_list" do
      get :edit, {project_id: @project.id, :id => @todo_list.id}
      expect(assigns(:todo_list)).to eq(@todo_list)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TodoList" do
        expect {
          post :create, {project_id: @project.id, :todo_list => valid_attributes}
        }.to change(TodoList, :count).by(1)
      end

      it "assigns a newly created todo_list as @todo_list" do
        post :create, {project_id: @project.id, :todo_list => valid_attributes}
        expect(assigns(:todo_list)).to be_a(TodoList)
        expect(assigns(:todo_list)).to be_persisted
      end

      it "redirects to the created todo_list" do
        post :create, {project_id: @project.id, :todo_list => valid_attributes}
        expect(response).to redirect_to(@project)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved todo_list as @todo_list" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(TodoList).to receive(:save).and_return(false)
        post :create, {project_id: @project.id, :todo_list => {name: ""  }}
        expect(assigns(:todo_list)).to be_a_new(TodoList)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(TodoList).to receive(:save).and_return(false)
        post :create, {project_id: @project.id, :todo_list => {name: ""  }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested todo_list" do
        allow(controller).to receive(:track_todo_list_activity).and_return(true)
        expect_any_instance_of(TodoList).to receive(:update_attributes).with({ name: "newlist" })
        patch :update, {project_id: @project.id, :id => @todo_list.id, :todo_list => { name: "newlist" }}
      end

      it "assigns the requested todo_list as @todo_list" do
        allow(controller).to receive(:track_todo_list_activity).and_return(true)
        patch :update, {project_id: @project.id, :id => @todo_list.id, :todo_list => valid_attributes}
        expect(assigns(:todo_list)).to eq(@todo_list)
      end

      it "redirects to the todo_list" do
        allow(controller).to receive(:track_todo_list_activity).and_return(true)
        patch :update, {project_id: @project.id, :id => @todo_list.id, :todo_list => valid_attributes}
        expect(response).to redirect_to([@project, @todo_list])
      end
    end

    describe "with invalid params" do
      it "assigns the todo_list as @todo_list" do
        expect_any_instance_of(TodoList).to receive(:save).and_return(false)
        patch :update, {project_id: @project.id, :id => @todo_list.id, :todo_list => {name: ""  }}
        expect(assigns(:todo_list)).to eq(@todo_list)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(TodoList).to receive(:save).and_return(false)
        patch :update, {project_id: @project.id, :id => @todo_list.id, :todo_list => {name: ""  }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested todo_list" do
      expect {
        delete :destroy, {project_id: @project.id, :id => @todo_list.id}
      }.to change(TodoList, :count).by(-1)
    end

    it "redirects to the todo_lists list" do
      delete :destroy, {project_id: @project.id, :id => @todo_list.id}
      expect(response).to redirect_to(@project)
    end
  end

  describe "GET closed" do
    it "assigns closed todos" do
      @todo = FactoryGirl.create(:todo, todo_list_id: @todo_list.id)
      @second_todo = FactoryGirl.create(:todo, todo_list_id: @todo_list.id)
      @todo.close
      get :closed, {project_id: @project.id, :id => @todo_list.id}
      expect(assigns(:closed_todos)).to eq([@todo])
    end
  end

end
