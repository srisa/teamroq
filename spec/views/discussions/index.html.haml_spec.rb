require 'rails_helper'

describe "discussions/index" do
  before(:each) do
    allow(view).to receive(:will_paginate).and_return(true)
    @project = FactoryGirl.create(:project, name: "Vennelo")
    @discussions = [FactoryGirl.create(:discussion, title: "Important"),
                    FactoryGirl.create(:discussion, title: "Priority")]
  end

  it "renders links" do
    render
    expect(rendered).to have_link("Dashboard")
    expect(rendered).to have_link("Users")
    expect(rendered).to have_link("Discussions")
    expect(rendered).to have_link("Standup Meeting")
    expect(rendered).to have_link("UPDATED TODAY")
    expect(rendered).to have_link("MOST POPULAR")
    expect(rendered).to have_link("FOLLOWED BY ME")
    expect(rendered).to have_link("CREATED BY ME")
    expect(rendered).to have_link("Start a Discussion")
  end

  it "renders a list of discussions" do
    render
    expect(rendered).to match /Important/
    expect(rendered).to match /Priority/
  end
end
