require 'rails_helper'

describe "activities/index" do
	before(:each) do
		@activities = FactoryGirl.create_list(:activity, 9)
		assign(:activities, @activities)
	end

	it "renders the sidebar" do
		render
		expect(rendered).to have_link("Dashboard")
	end

	it "renders loading gif" do
		render
		expect(rendered).to match /ajax-loader/
	end

	it "renders activities" do
		render
		expect(rendered).to match /questions/
	end

end