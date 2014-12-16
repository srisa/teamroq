require 'rails_helper'
require 'will_paginate/array'

describe "projects/users" do
  before(:each) do
    @project = FactoryGirl.create(:project, name: "design")
    5.times do |i|
      name = "Name" + i.to_s
      @user = FactoryGirl.create(:user, name: name)
      @user.projects.push @project
    end
    assign(:project, @project)
    assign(:users, @project.users.paginate(per_page: 5, page: 1))
  end

  it "renders all side bar links" do
    render
    expect(rendered).to have_link("Dashboard")
    expect(rendered).to have_link("Users")
    expect(rendered).to have_link("Discussions")
    expect(rendered).to have_link("Standup Meeting")
    expect(rendered).to have_link("Documents")
  end

  it "renders users" do
    render
    expect(rendered).to match /Name0/
    expect(rendered).to match /Name1/
    expect(rendered).to match /Name2/
    expect(rendered).to match /Name3/
    expect(rendered).to match /Name4/
  end

  it "renders add user modal" do
    render
    expect(rendered).to match /add-user-form/
    expect(rendered).to have_button("Add Users")
  end

end