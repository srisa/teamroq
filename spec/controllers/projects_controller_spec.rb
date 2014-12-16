require 'rails_helper'

describe ProjectsController do

  before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @project = FactoryGirl.create(:project)
      @user = FactoryGirl.create(:user)
      @user.projects.push @project
      sign_in @user
  end

  let(:valid_attributes) {{ name: "Test Project"}}

  describe "GET index" do

    it "assigns all projects as @projects" do
      get :index
      expect(assigns(:projects)).to eq([@project]) 
    end
    it "assigns percentages" do
      get :index
      expect(assigns(:percentages)).to eq({@project.id => 0})
    end

  end

  describe "GET show" do
    it "assigns the requested project as @project" do
      get :show, {:id => @project.id}
      expect(assigns(:project)).to eq(@project)
    end
  end

  describe "GET new" do
    it "assigns a new project as @project" do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe "GET edit" do
    it "assigns the requested project as @project" do
      get :edit, {:id => @project.id}
      expect(assigns(:project)).to eq(@project)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, {:project => valid_attributes}
        }.to change(Project, :count).by(1)
      end

      it "creates new Project Role" do
        expect {
          post :create, {:project => valid_attributes}
        }.to change(ProjectRole, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, {:project => valid_attributes}
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it "redirects to the created project" do
        post :create, {:project => valid_attributes}
        expect(response).to redirect_to(Project.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project as @project" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Project).to receive(:save).and_return(false)  
        post :create, {:project => { "name" => "" }}
        expect(assigns(:project)).to be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Project).to receive(:save).and_return(false)
        post :create, {:project => { "name" => "" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      it "updates the requested project" do
        expect_any_instance_of(Project).to receive(:update_attributes).with({ "name" => "MyString" })
        patch :update, {:id => @project.id, :project => { "name" => "MyString" }}
      end

      it "assigns the requested project as @project" do
        patch :update, {:id => @project.id, :project => valid_attributes}
        expect(assigns(:project)).to eq(@project)
      end

      it "redirects to the project" do
        patch :update, {:id => @project.id, :project => valid_attributes}
        expect(response).to redirect_to(@project)
      end
    end

    describe "with invalid params" do
      it "assigns the project as @project" do
        expect_any_instance_of(Project).to receive(:save).and_return(false)
        patch :update, {:id => @project.id, :project => { "name" => "" }}
        expect(assigns(:project)).to eq(@project)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(Project).to receive(:save).and_return(false)
        patch :update, {:id => @project.id, :project => { "name" => "" }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
  
    it "destroys the requested project as admin" do
      expect {
        delete :destroy, {:id => @project.id}
      }.to change(Project, :count).by(0)
    end

    it "destroys the requested project as others" do
      @user.add_role :manager, @project
      expect {
        delete :destroy, {:id => @project.id}
      }.to change(Project, :count).by(-1)
    end

    it "redirects to the projects list" do
      delete :destroy, {:id => @project.id}
      expect(response).to redirect_to(projects_path)
    end
  end

  describe "POST add_users" do
    before(:each) do
      request.env["HTTP_REFERER"] = "/"
    end

    it "redirects back after completion" do
      project = @user.projects.create!(valid_attributes)
      users = FactoryGirl.create_list(:user,3)
      list = users.collect(&:id).join(",")
      post :add_users, {user_list: list ,project_id: project.id}
      expect(response).to redirect_to("/")
    end

    it "redirects back if user list is empty" do
      project = @user.projects.create!(valid_attributes)
      post :add_users, {project_id: project.id}
      expect(response).to redirect_to("/")
    end
  end

  describe "GET documents" do
    before(:each) do
      @document = FactoryGirl.create(:document)
      @second_document = FactoryGirl.create(:document)  
      @project.documents.push @document
      @project.documents.push @second_document
    end

    it "assigns document as new" do
      get :documents, {id: @project.id}
      expect(assigns(:document)).to be_a_new(Document)
    end

    it "assigns documents" do    
      get :documents, {id: @project.id}
      expect(assigns(:documents)).to eq([@second_document, @document])

    end

    it "assigns documents for documents/today" do
      @second_document.update_attributes(updated_at: 2.days.ago)
      get :documents, {id: @project.id, filter: "today"}
      expect(assigns(:documents)).to eq([@document])
      expect(assigns(:document)).to be_a_new(Document)
    end

    it "assigns documents for documents/popular" do
      @second_document.update_attributes(updated_at: 2.days.ago)
      get :documents, {id: @project.id, filter: "popular"}
      expect(assigns(:documents)).to eq([@second_document, @document])
      expect(assigns(:document)).to be_a_new(Document)
    end

    it "assigns documents for documents/byme" do
      @second_document.update_attributes(user_id: @user.id)
      get :documents, {id: @project.id, filter: "byme"}
      expect(assigns(:documents)).to eq([@second_document])
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe "GET users" do
    it "assigns the users" do
      get :users, {id: @project.id}
      expect(assigns(:users)).to eq([@user])
    end
  end

  describe "GET standup" do
    before(:each) do
      @todo_list = FactoryGirl.create(:todo_list, project_id: @project.id)
      @todo = FactoryGirl.create(:todo, todo_list_id: @todo_list.id, user_id: @user.id)
      @second_todo = FactoryGirl.create(:todo, todo_list_id: @todo_list.id, user_id: @user.id)
      @second_todo.closed_on = Time.zone.now
      @second_todo.close
    end

    it "assigns open todos" do
      get :standup, {id: @project.id}
      expect(assigns(:open_todos)).to eq({@user =>[@todo]})
    end

    it "assigns closed today" do
      get :standup, {id: @project.id}
      expect(assigns(:closed_today)).to eq({@user => [@second_todo]})
    end
  end

end
