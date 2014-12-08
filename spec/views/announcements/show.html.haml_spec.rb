require 'rails_helper'

describe "announcements/show" do
  before(:each) do
    assign(:group, FactoryGirl.create(:group))
    assign(:announcement, FactoryGirl.create(:announcement, content: "Venello"))
  end

  it "renders the content" do
    render
   	expect(rendered).to match /Venello/
  end
end
