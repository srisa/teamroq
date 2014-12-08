require 'rails_helper'

describe ProjectRolesController do
  describe "routing" do
  	it "routes to #create" do
  		expect(patch("/projects/1/add_user")).to route_to("project_roles#create", id: "1")
  	end

  	it "routes to #destroy" do
  		expect(patch("/projects/1/remove_user")).to route_to("project_roles#destroy", id: "1")
  	end
  end
end
