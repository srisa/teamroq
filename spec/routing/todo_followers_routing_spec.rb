require 'rails_helper'

describe TodoFollowersController do
  describe "routing" do
  	it "routes to #follow" do
  		expect(patch("/todo_lists/1/todos/1/follow")).to route_to("todo_followers#create", todo_list_id: "1", id: "1")
  	end

  	it "routes to #unfollow" do
  		expect(patch("/todo_lists/1/todos/1/unfollow")).to route_to("todo_followers#destroy", todo_list_id: "1", id: "1")
  	end

  	it "routes to #add_followers" do
  		expect(patch("/todo_lists/1/todos/1/add_followers")).to route_to("todo_followers#add_followers", todo_list_id: "1", id: "1")
  	end
  end
end

