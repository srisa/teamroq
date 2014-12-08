require 'rails_helper'

describe "announcements/edit" do
  before(:each) do
    assign(:announcable, FactoryGirl.create(:group))
    assign(:announcement, FactoryGirl.build(:announcement))
  end

  it "renders edit announcement form" do
    render
    expect(rendered).to match /announcement\[content\]/
    expect(rendered).to have_button("Save")
  end
end
