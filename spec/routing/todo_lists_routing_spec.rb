require 'rails_helper'

describe TodoListsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("projects/1/todo_lists")).to route_to("todo_lists#index", project_id: "1")
    end

    it "routes to #new" do
      expect(get("projects/1/todo_lists/new")).to route_to("todo_lists#new", project_id: "1")
    end

    it "routes to #show" do
      expect(get("projects/1/todo_lists/1")).to route_to("todo_lists#show", id: "1", project_id: "1")
    end

    it "routes to #edit" do
      expect(get("projects/1/todo_lists/1/edit")).to route_to("todo_lists#edit", id: "1", project_id: "1")
    end

    it "routes to #create" do
      expect(post("projects/1/todo_lists")).to route_to("todo_lists#create", project_id: "1")
    end

    it "routes to #update" do
      expect(patch("projects/1/todo_lists/1")).to route_to("todo_lists#update", id: "1", project_id: "1")
    end

    it "routes to #destroy" do
      expect(delete("projects/1/todo_lists/1")).to route_to("todo_lists#destroy", id: "1", project_id: "1")
    end

    it "routes to #closed" do
      expect(get("projects/1/todo_lists/1/closed")).to route_to("todo_lists#closed", id: "1", project_id: "1")
    end

  end
end
