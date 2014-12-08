require 'rails_helper'

describe "groups/new" do
  before(:each) do
    assign(:group, FactoryGirl.build(:group))
  end

  it "renders new group form" do
    render
    expect(rendered).to match /Add a Group/
    expect(rendered).to match /Enter group name/
    expect(rendered).to match /Enter group description/
    expect(rendered).to match /Save Group/
  end
end
