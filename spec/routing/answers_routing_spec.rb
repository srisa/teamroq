require 'rails_helper'

describe AnswersController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/questions/1/answers")).to route_to("answers#index", question_id: "1")
    end

    it "routes to #new" do
      expect(get("/questions/1/answers/new")).to route_to("answers#new", question_id: "1")
    end

    it "routes to #show" do
      expect(get("/questions/1/answers/1")).to route_to("answers#show", id: "1", question_id: "1")
    end

    it "routes to #edit" do
      expect(get("/questions/1/answers/1/edit")).to route_to("answers#edit", id: "1", question_id: "1")
    end

    it "routes to #create" do
      expect(post("/questions/1/answers")).to route_to("answers#create", question_id: "1")
    end

    it "routes to #update" do
      expect(put("/questions/1/answers/1")).to route_to("answers#update", id: "1", question_id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/questions/1/answers/1")).to route_to("answers#destroy", id: "1", question_id: "1")
    end

    it "activity comments route to #activitycomments" do
      expect(get("/answers/1/activitycomments/1")).to route_to("comments#activitycomments", answer_id: "1", activity_id: "1")
    end

    it "routes to #vote" do
      expect(post("/answers/1/vote")).to route_to("answers#vote", id: "1")
    end

    it "routes to #markanswer" do
      expect(post("/answers/1/markanswer")).to route_to("answers#markanswer", id: "1")
    end

  end
end
