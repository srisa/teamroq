require 'rails_helper'
require 'rack/test'

describe DocumentsController do

  before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @document = FactoryGirl.create(:document)
      @project = @document.attachable
      @user = FactoryGirl.create(:user)
      sign_in @user
  end

  let(:valid_attributes){
    { name: "document"}
  }

  let(:document_version_attributes){{
    file: Rack::Test::UploadedFile.new(Rails.root + 'spec/factories/add.png', 'image/png'),
    release_note: "first release"
    }}

  describe "GET index" do
    it "assigns all documents as @documents" do
      get :index, {project_id: @project.id}
      expect(assigns(:documents)).to eq([@document])
    end
  end

  describe "GET show" do
    it "assigns the requested document as @document" do
      get :show, {project_id: @project.id, :id => @document.id}
      expect(assigns(:document)).to eq(@document)
    end
  end

  describe "GET new" do
    it "assigns a new document as @document" do
      get :new, {project_id: @project.id}
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe "GET edit" do
    it "assigns the requested document as @document" do
      get :edit, {project_id: @project.id, :id => @document.id}
      expect(assigns(:document)).to eq(@document)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Document" do
        expect {
          post :create, {project_id: @project.id, :document => valid_attributes, document_versions_attributes: document_version_attributes}
        }.to change(Document, :count).by(1)
      end

      it "assigns a newly created document as @document" do
        post :create, {project_id: @project.id, :document => valid_attributes}
        expect(assigns(:document)).to be_a(Document)
        expect(assigns(:document)).to be_persisted
      end

      it "redirects to the created document" do
        post :create, {project_id: @project.id, :document => valid_attributes}
        expect(response).to redirect_to([@project, :documents])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document as @document" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Document).to receive(:save).and_return(false)
        post :create, {project_id: @project.id, :document => { name: "" }}
        expect(assigns(:document)).to be_a_new(Document)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect_any_instance_of(Document).to receive(:save).and_return(false)
        post :create, {project_id: @project.id, :document => { name: "" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH update" do
    describe "with valid params" do
      # TODO 
      # it "updates the requested document" do
      #   allow(controller).to receive(:track_document_activity).and_return(true)
      #   expect_any_instance_of(Document).to receive(:update_attributes).with({ "name" => "MyString" })
      #   patch :update, {project_id: @project.id, :id => @document.id, :document => { "name" => "MyString" }}
      # end

      it "creates a new document version" do
        allow(controller).to receive(:track_document_activity).and_return(true)
        expect{
        patch :update, {project_id: @project.id, :id => @document.id, :document => { "name" => "MyString" }, document_versions: document_version_attributes}
        }.to change(DocumentVersion, :count).by(1)
      end

      it "assigns the requested document as @document" do
        allow(controller).to receive(:track_document_activity).and_return(true)
        patch :update, {project_id: @project.id, :id => @document.id, :document => valid_attributes, document_versions: document_version_attributes}
        expect(assigns(:document)).to eq(@document)
      end

      it "redirects to the document" do
        allow(controller).to receive(:track_document_activity).and_return(true)
        patch :update, {project_id: @project.id, :id => @document.id, :document => valid_attributes, document_versions: document_version_attributes}
        expect(response).to redirect_to([@project, @document])
      end
    end

    describe "with invalid params" do
      it "assigns the document as @document" do
        expect_any_instance_of(Document).to receive(:save).and_return(false)
        patch :update, {project_id: @project.id, :id => @document.id, :document => { name: "" }, document_versions: {file: "", release_note: ""}}
        expect(assigns(:document)).to eq(@document)
      end

      it "re-renders the 'edit' template" do
        expect_any_instance_of(Document).to receive(:save).and_return(false)
        patch :update, {project_id: @project.id, :id => @document.id, :document => { name: "" }, document_versions: {file: "", release_note: ""}}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested document" do
      expect {
        delete :destroy, {project_id: @project.id, :id => @document.id}
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the documents list" do
      delete :destroy, {project_id: @project.id, :id => @document.id}
      expect(response).to redirect_to([@project, :documents])
    end
  end

  describe "GET download" do
    it "redirects to download url" do
      @version = FactoryGirl.create(:document_version)
      @document.document_versions.push @version
      get :download, {project_id: @project.id, :id => @document.id}
      expect(response).to redirect_to(@version.file.url)
    end
  end

  describe "POST attachment" do
    describe "with valid params" do
      it "creates a new document" do
        expect {
          post :attachment, {project_id: @project.id, document_version: document_version_attributes, format: "json"}
        }.to change(Document, :count).by(1)
      end
      it "creates a new document version" do
        expect {
          post :attachment, {project_id: @project.id, document_version: document_version_attributes, format: "json"}
        }.to change(DocumentVersion, :count).by(1)
      end

      it "assigns document" do
         post :attachment, {project_id: @project.id, document_version: document_version_attributes, format: "json"}
         expect(assigns(:document)).to be_a(Document)
         expect(assigns(:document)).to be_persisted
      end

      it "assigns document  version" do
         post :attachment, {project_id: @project.id, document_version: document_version_attributes, format: "json"}
         expect(assigns(:document_version)).to be_a(DocumentVersion)
         expect(assigns(:document_version)).to be_persisted
      end

      it "renders json" do
        post :attachment, {project_id: @project.id, document_version: document_version_attributes, format: "json"}
        expect(response.body).to match /created/i      
      end
    end

    describe "invalid params" do
      it "renders unprocessable entity" do
        post :attachment, {project_id: @project.id, document_version: {file: "", release_note: ""}, format: "json"}
        expect(response.status).to eq(422)
      end
    end
  end
end
