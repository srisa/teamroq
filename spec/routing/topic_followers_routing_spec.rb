require 'rails_helper'

describe TopicFollowerController do
  describe "routing" do
  	it "routes to #create" do
      expect(patch("/topics/name/follow")).to route_to("topic_follower#create", name: "name")
    end

    it "routes to #destroy" do
      expect(patch("/topics/name/unfollow")).to route_to("topic_follower#destroy", name: "name")
    end
  end
end
