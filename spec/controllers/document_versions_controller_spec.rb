require 'rails_helper'
require 'rack/test'

describe DocumentVersionsController do

	before(:each) do
    @user = FactoryGirl.create(:user)
    @document = FactoryGirl.create(:document)
    @project = @document.attachable
    @document_version = FactoryGirl.create(:document_version, document_id: @document.id)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end

  let(:valid_attributes){{
  	file: Rack::Test::UploadedFile.new(Rails.root + 'spec/factories/add.png', 'image/png'),
  	release_note: "first release"
  }
  }



	describe "POST create" do
    before(:each) do
      allow(controller).to receive(:track_document_activity).and_return(true)
      request.env["HTTP_REFERER"] = "/"
    end

    describe "with valid params" do
      it "creates a new DocumentVersion" do
        expect {
          post :create, {project_id: @project.id, document_id: @document.id, document_version: valid_attributes}
        }.to change(DocumentVersion, :count).by(1)
      end

      it "assigns a newly created document_version as @document_version" do
        post :create, {project_id: @project.id, document_id: @document.id, document_version: valid_attributes}
        expect(assigns(:document_version)).to be_a(DocumentVersion)
        expect(assigns(:document_version)).to be_persisted
      end

      it "redirects to the question" do
        post :create, {project_id: @project.id, document_id: @document.id, document_version: valid_attributes}
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "GET download" do
    it "assings the document_version" do
      get :download, {project_id: @project.id, document_id: @document.id, document_version_id: @document_version.id}
      expect(assigns(:document_version)).to eq(@document_version)
    end

    it "redirects to download path" do
       get :download, {project_id: @project.id, document_id: @document.id, document_version_id: @document_version.id}
       expect(response).to redirect_to(@document_version.file.url)
     end
     
  end

end
