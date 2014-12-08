require 'rails_helper'

describe GroupRolesController do
  describe "routing" do
  	it "routes to #create" do
  		expect(patch("/groups/1/add_user")).to route_to("group_roles#create", id: "1")
  	end

  	it "routes to #destroy" do
  		expect(patch("/groups/1/remove_user")).to route_to("group_roles#destroy", id: "1")
  	end
  end
end
