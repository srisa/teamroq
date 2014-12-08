require 'rails_helper'

describe DiscussionsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/projects/1/discussions")).to route_to("discussions#index", project_id: "1")
    end

    it "routes to #new" do
       expect(get("/projects/1/discussions/new")).to route_to("discussions#new", project_id: "1")
    end

    it "routes to #show" do
      expect(get("/projects/1/discussions/1")).to route_to("discussions#show", id: "1", project_id: "1")
    end

    it "routes to #edit" do
      expect(get("/projects/1/discussions/1/edit")).to route_to("discussions#edit", id: "1", project_id: "1")
    end

    it "routes to #create" do
      expect(post("/projects/1/discussions")).to route_to("discussions#create", project_id: "1")
    end

    it "routes to #update" do
      expect(put("/projects/1/discussions/1")).to route_to("discussions#update", id: "1", project_id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/projects/1/discussions/1")).to route_to("discussions#destroy", id: "1", project_id: "1")
    end

    it "activity comments route to #activitycomments" do
      expect(get("/discussions/1/activitycomments/1")).to route_to("comments#activitycomments", discussion_id: "1", activity_id: "1")
    end

    it "search user to #searchuser" do
      expect(get("/projects/1/discussions/searchuser")).to route_to("discussions#searchuser", project_id: "1")
    end

    it "routes to filter" do
      expect(get("/projects/1/discussions/filter/today")).to route_to("discussions#index", filter: "today", project_id: "1")
    end

  end
end
