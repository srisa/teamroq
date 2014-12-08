require 'rails_helper'

describe "groups/index" do
  before(:each) do
    allow(view).to receive(:will_paginate).and_return(false)
    assign(:groups, [
      FactoryGirl.create(:group, name: "Test1"),
      FactoryGirl.create(:group, name: "Test2")
    ])
  end

  it "renders a list of groups" do
    render
    expect(rendered).to match /Test1/
    expect(rendered).to match /Test2/
    expect(rendered).to match /0/
    expect(rendered).to have_link("Create a Group")
  end
end
