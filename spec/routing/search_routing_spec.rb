require 'rails_helper'
describe SearchController do
  describe "routing" do

    it "routes to #autocomplete" do
      expect(get("/search/autocomplete")).to route_to("search#autocomplete")
    end

    it "routes to #autocomplete_tag" do
      expect(get("/search/autocomplete_tag")).to route_to("search#autocomplete_tag")
    end

    it "routes to #autocomplete_user" do
      expect(get("/search/autocomplete_user")).to route_to("search#autocomplete_user")
    end

  end
end