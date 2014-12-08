require 'rails_helper'

describe QuestionsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/questions")).to route_to("questions#index")
    end

    it "routes to #new" do
      expect(get("/questions/new")).to route_to("questions#new")
    end

    it "routes to #show" do
      expect(get("/questions/1")).to route_to("questions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("/questions/1/edit")).to route_to("questions#edit", id: "1")
    end

    it "routes to #create" do
      expect(post("/questions")).to route_to("questions#create")
    end

    it "routes to #update" do
      expect(patch("/questions/1")).to route_to("questions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/questions/1")).to route_to("questions#destroy", id: "1")
    end

    it "activity comments route to #activitycomments" do
      expect(get("/questions/1/activitycomments/1")).to route_to("comments#activitycomments", question_id: "1", activity_id: "1")
    end


    it "routes topics to #topic " do
      expect(get("/topics/java")).to route_to("questions#topic", tag: "java" )
    end

    it "routes to #untag" do
      expect(patch("/questions/1/untag")).to route_to("questions#untag", id: "1")
    end

     it "routes to #tag" do
      expect(patch("/questions/1/tag")).to route_to("questions#tag", id: "1")
    end

    it "routes to #vote" do
      expect(post("/questions/1/vote")).to route_to("questions#vote", id: "1")
    end

  end
end
