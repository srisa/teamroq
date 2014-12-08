require 'rails_helper'

describe DocumentsController do
  describe "Project, Group document routes" do

    it "routes to #new" do
      expect(get("/projects/1/documents/new")).to route_to("documents#new", :project_id => "1")
      expect(get("/groups/1/documents/new")).to route_to("documents#new", :group_id => "1")
    end

    it "routes to #show" do
      expect(get("/projects/1/documents/1")).to route_to("documents#show", :id => "1", :project_id => "1")
      expect(get("/groups/1/documents/1")).to route_to("documents#show", :id => "1", :group_id => "1")
    end

    it "routes to #edit" do
      expect(get("/projects/1/documents/1/edit")).to route_to("documents#edit", :id => "1", :project_id => "1")
      expect(get("/groups/1/documents/1/edit")).to route_to("documents#edit", :id => "1", :group_id => "1")
    end

    it "routes to #create" do
      expect(post("/projects/1/documents")).to route_to("documents#create", :project_id => "1")
      expect(post("/groups/1/documents")).to route_to("documents#create", :group_id => "1")
    end

    it "routes to #update" do
      expect(patch("/projects/1/documents/1")).to route_to("documents#update", :id => "1", :project_id => "1")
      expect(patch("/groups/1/documents/1")).to route_to("documents#update", :id => "1", :group_id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/projects/1/documents/1")).to route_to("documents#destroy", :id => "1", :project_id => "1")
      expect(delete("/groups/1/documents/1")).to route_to("documents#destroy", :id => "1", :group_id => "1")
    end

    it "routes attachments" do
      expect(post("/projects/1/attachments")).to route_to("documents#attachment", project_id: "1")
      expect(post("/groups/1/attachments")).to route_to("documents#attachment", group_id: "1")
    end

    it "routes downloads" do
      expect(get("/projects/1/documents/1/download")).to route_to("documents#download", project_id: "1", id: "1")
      expect(get("/groups/1/documents/1/download")).to route_to("documents#download", group_id: "1", id: "1")
    end

  end
end
