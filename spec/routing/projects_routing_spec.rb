require 'rails_helper'

describe ProjectsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/projects")).to route_to("projects#index")
    end

    it "routes to #new" do
      expect(get("/projects/new")).to route_to("projects#new")
    end

    it "routes to #show" do
      expect(get("/projects/1")).to route_to("projects#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("/projects/1/edit")).to route_to("projects#edit", id: "1")
    end

    it "routes to #create" do
      expect(post("/projects")).to route_to("projects#create")
    end

    it "routes to #update" do
      expect(patch("/projects/1")).to route_to("projects#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/projects/1")).to route_to("projects#destroy", id: "1")
    end

    it "routes search user" do
      expect(post("/projects/add_users")).to route_to("projects#add_users")
    end

    it "routes documents" do
      expect(get("/projects/1/documents")).to route_to("projects#documents", id: "1")
    end

    it "routes standup" do
      expect(get("/projects/1/standup")).to route_to("projects#standup", id: "1")
    end

    it "routes users" do
      expect(get("/projects/1/users")).to route_to("projects#users", id: "1")
    end

    it "routes charts" do
      expect(get("/projects/1/charts")).to route_to("projects#charts", id: "1")
    end

  end
end
