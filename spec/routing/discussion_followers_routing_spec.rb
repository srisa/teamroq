require 'rails_helper'
describe DiscussionFollowersController do
	describe "#routing" do
		it "routes to #follow" do
	      expect(patch("/projects/1/discussions/1/follow")).to route_to("discussion_followers#create", id: "1", project_id: "1")
	    end

	    it "routes to #unfollow" do
	      expect(patch("/projects/1/discussions/1/unfollow")).to route_to("discussion_followers#destroy", id: "1", project_id: "1")
	    end

	    it "routes to #add_followers" do
	      expect(patch("/projects/1/discussions/1/add_followers")).to route_to("discussion_followers#add_followers", id: "1", project_id: "1")
	    end
	end
end
