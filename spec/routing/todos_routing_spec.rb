require 'rails_helper'

describe TodosController do
  describe "routing" do
    it "routes to #index" do
      expect(get("/todo_lists/1/todos")).to route_to("todos#index", todo_list_id: "1")
    end

    it "routes to #new" do
      expect(get("/todo_lists/1/todos/new")).to route_to("todos#new", todo_list_id: "1")
    end

    it "routes to #show" do
      expect(get("/todo_lists/1/todos/1")).to route_to("todos#show", id: "1", todo_list_id: "1")
    end

    it "routes to #edit" do
      expect(get("/todo_lists/1/todos/1/edit")).to route_to("todos#edit", id: "1", todo_list_id: "1")
    end

    it "routes to #create" do
      expect(post("/todo_lists/1/todos")).to route_to("todos#create", todo_list_id: "1")
    end

    it "routes to #update" do
      expect(patch("/todo_lists/1/todos/1")).to route_to("todos#update", id: "1", todo_list_id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/todo_lists/1/todos/1")).to route_to("todos#destroy", id: "1", todo_list_id: "1")
    end

    it "activity comments route to #activitycomments" do
      expect(get("/todos/1/activitycomments/1")).to route_to("comments#activitycomments", todo_id: "1", activity_id: "1")
    end

    it "search user to #searchuser" do
      expect(get("/todo_lists/1/todos/searchuser")).to route_to("todos#searchuser", todo_list_id: "1")
    end

    it "routes add watcher task" do
      expect(get("/todos/addwatcher_task")).to route_to("todos#searchuser")
    end

    it "routes search user" do
      expect(get("/todos/searchuser")).to route_to("todos#searchuser")
    end

    it "routes to #close" do
      expect(patch("/todo_lists/1/todos/1/close")).to route_to("todos#close", id: "1", todo_list_id: "1")
    end


    it "routes to #reopen" do
      expect(patch("/todo_lists/1/todos/1/reopen")).to route_to("todos#reopen", id: "1", todo_list_id: "1")
    end

    it "routes to #state_history" do
      expect(patch("/todo_lists/1/todos/1/state_history")).to route_to("todos#state_history", id: "1", todo_list_id: "1")
    end

    it "routes to #change_date" do
      expect(patch("/todo_lists/1/todos/1/change_date")).to route_to("todos#change_date", id: "1", todo_list_id: "1")
    end

    it "routes to #change_user" do
      expect(patch("/todo_lists/1/todos/1/change_user")).to route_to("todos#change_user", id: "1", todo_list_id: "1")
    end

    it "routes to #change_user" do
      expect(patch("/todo_lists/1/todos/1/change_user")).to route_to("todos#change_user", id: "1", todo_list_id: "1")
    end

  end
end
