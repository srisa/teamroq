require 'rails_helper'

describe FollowersController do
  describe "routing" do

  	it "routes to post #follow" do
  		expect(patch("/users/1/follow")).to route_to("followers#create", id: "1")
    end

    it "routes to post #unfollow" do
      expect(patch("/users/1/unfollow")).to route_to("followers#destroy", id: "1")
    end
  end
end

