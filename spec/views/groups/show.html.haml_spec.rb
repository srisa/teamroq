require 'rails_helper'

describe "groups/show" do
  before(:each) do
    @group = assign(:group, FactoryGirl.create(:group, name: "Test"))
    @posts = assign(:posts, [FactoryGirl.create(:post, content: "Test Post")])
  end

  it "renders links" do
    render
    expect(rendered).to have_link("Dashboard")
    expect(rendered).to have_link("Users")
    expect(rendered).to have_link("Announcements")
    expect(rendered).to have_link("Documents")
  end

  it "renders groups" do
    render
    expect(rendered).to match /Test/
    expect(rendered).to match /Test Post/
  end
end
