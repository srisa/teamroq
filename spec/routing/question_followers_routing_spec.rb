require 'rails_helper'

describe QuestionFollowersController do
  describe "routing" do
  	it "routes to #follow" do
  		expect(patch("/questions/1/follow")).to route_to("question_followers#create", id: "1")
  	end

  	it "routes to #unfollow" do
  		expect(patch("/questions/1/unfollow")).to route_to("question_followers#destroy", id: "1")
  	end
  end
end
