require 'rails_helper'

describe AnnouncementsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/groups/1/announcements")).to route_to("announcements#index", :group_id => "1")
    end

    it "routes to #new" do
      expect(get("/groups/1/announcements/new")).to route_to("announcements#new", :group_id => "1")
    end

    it "routes to #show" do
      expect(get("/groups/1/announcements/1")).to route_to("announcements#show", :id => "1", :group_id => "1")
    end

    it "routes to #edit" do
      expect(get("/groups/1/announcements/1/edit")).to route_to("announcements#edit", :id => "1", :group_id => "1")
    end

    it "routes to #create" do
      expect(post("/groups/1/announcements")).to route_to("announcements#create", :group_id => "1")
    end

    it "routes to #update" do
      expect(put("/groups/1/announcements/1")).to route_to("announcements#update", :id => "1", :group_id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/groups/1/announcements/1")).to route_to("announcements#destroy", :id => "1", :group_id => "1")
    end

  end
end
