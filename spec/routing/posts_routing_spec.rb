require 'rails_helper'

describe PostsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/groups/1/posts")).to route_to("posts#index",group_id: "1")
      expect(get("/users/1/posts")).to route_to("posts#index",user_id: "1")
    end

    it "routes to #new" do
      expect(get("/groups/1/posts/new")).to route_to("posts#new",group_id: "1")
      expect(get("/users/1/posts/new")).to route_to("posts#new",user_id: "1")
    end

    it "routes to #show" do
      expect(get("/groups/1/posts/1")).to route_to("posts#show", id: "1",group_id: "1")
      expect(get("/users/1/posts/1")).to route_to("posts#show", id: "1",user_id: "1")
    end

    it "routes to #edit" do
      expect(get("/groups/1/posts/1/edit")).to route_to("posts#edit", id: "1",group_id: "1")
      expect(get("/users/1/posts/1/edit")).to route_to("posts#edit", id: "1",user_id: "1")
    end

    it "routes to #create" do
      expect(post("/groups/1/posts")).to route_to("posts#create",group_id: "1")
      expect(post("/users/1/posts")).to route_to("posts#create",user_id: "1")
    end

    it "routes to #update" do
      expect(patch("/groups/1/posts/1")).to route_to("posts#update", id: "1",group_id: "1")
      expect(patch("/users/1/posts/1")).to route_to("posts#update", id: "1",user_id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/groups/1/posts/1")).to route_to("posts#destroy", id: "1",group_id: "1")
      expect(delete("/users/1/posts/1")).to route_to("posts#destroy", id: "1",user_id: "1")
    end

    it "activity comments route to #activitycomments" do
      expect(get("/posts/1/activitycomments/1")).to route_to("comments#activitycomments", post_id: "1", activity_id: "1")
    end

    it "routes to #follow" do
      expect(patch("/groups/1/posts/1/follow")).to route_to("posts#follow", id: "1",group_id: "1")
    end

    it "routes to #unfollow" do
      expect(patch("/groups/1/posts/1/unfollow")).to route_to("posts#unfollow", id: "1",group_id: "1")
    end

    it "routes to #add_followers" do
      expect(patch("/groups/1/posts/1/add_followers")).to route_to("posts#add_followers", id: "1",group_id: "1")
    end

  end
end
