require 'rails_helper'

describe "announcements/index" do
  before(:each) do
    assign(:group, FactoryGirl.create(:group))
    assign(:announcements, [FactoryGirl.create(:announcement, content: "Veneelo")])
  end

  it "renders side bar links" do
    render
    expect(rendered).to have_link("Dashboard")
    expect(rendered).to have_link("Users")
    expect(rendered).to have_link("Announcements")
    expect(rendered).to have_link("Documents")
  end

  it "renders a list of announcements" do
    render
    expect(rendered).to match /Veneelo/
  end
end
