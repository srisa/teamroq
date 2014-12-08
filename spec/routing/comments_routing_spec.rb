require 'rails_helper'

describe CommentsController do
  describe "routing" do

    it "routes to #showcomment" do
      expect(get("/comments/showcomment")).to route_to("comments#showcomment")
    end

    it "routes to #activity_comment" do
      expect(post("/todos/1/comments/activity_comment")).to route_to("comments#activity_comment", todo_id: "1")
      expect(post("/discussions/1/comments/activity_comment")).to route_to("comments#activity_comment", discussion_id: "1")
      expect(post("/posts/1/comments/activity_comment")).to route_to("comments#activity_comment", post_id: "1")
      expect(post("/questions/1/comments/activity_comment")).to route_to("comments#activity_comment", question_id: "1")
      expect(post("/answers/1/comments/activity_comment")).to route_to("comments#activity_comment", answer_id: "1")
    end
    
  end
end
