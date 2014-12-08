require 'rails_helper'

describe "groups/edit" do
  before(:each) do
    @group = FactoryGirl.create(:group, name: "design")
    assign(:group, @group)
  end


  it "renders the edit group form" do
    render
    expect(rendered).to match /group\[name\]/
    expect(rendered).to match /group\[description\]/
    expect(rendered).to have_button("Save Group")
  end
end
