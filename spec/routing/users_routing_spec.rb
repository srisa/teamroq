require 'rails_helper'

describe UsersController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/users")).to route_to("users#index")
    end

    it "routes to #new" do
      expect(get("/users/new")).to route_to("users#new")
    end

    it "routes to #show" do
      expect(get("/users/1")).to route_to("users#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("/users/1/edit")).to route_to("users#edit", id: "1")
    end

    it "routes to #update" do
      expect(put("/users/1")).to route_to("users#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/users/1")).to route_to("users#destroy", id: "1")
    end

    it "routes to /documents" do
      expect(get("/documents")).to route_to("users#documents")
    end

    it "routes to /tasks" do
      expect(get("/tasks")).to route_to("users#tasks")
    end

    it "routes to /tasks/closed" do
      expect(get("/tasks/closed")).to route_to("users#closed")
    end

    it "routes to /tasks/created" do
      expect(get("/tasks/created")).to route_to("users#created_open_tasks")
    end

    it "routes to /tasks/created/closed" do
      expect(get("/tasks/created/closed")).to route_to("users#created_closed_tasks")
    end

    it "routes to /myquestions" do
      expect(get("/myquestions")).to route_to("users#myquestions")
    end

    it "routes to /mytopics" do
      expect(get("/mytopics")).to route_to("users#mytopics")
    end


  end
end
