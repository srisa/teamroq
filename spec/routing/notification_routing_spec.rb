require 'rails_helper'

describe NotificationsController do
  describe "routing" do
    it "routes to #index" do
      expect(get("/notifications/index")).to route_to("notifications#index")
    end

    it "routes to #show" do
      expect(get("/notifications/show")).to route_to("notifications#show")
    end

    it "routes to #showall" do
      expect(get("/notifications/showall")).to route_to("notifications#showall")
    end

  end
end