require 'rails_helper'

describe DocumentVersionsController do
  describe "download document routes" do

    it "routes to download" do
      expect(get("/projects/1/documents/1/document_versions/2/download")).to route_to("document_versions#download", project_id: "1", document_id: "1", document_version_id: "2")
      expect(get("/groups/1/documents/1/document_versions/2/download")).to route_to("document_versions#download", group_id: "1", document_id: "1", document_version_id: "2")
    end
  end
end
