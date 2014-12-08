require 'rails_helper'

describe "projects/index" do
  before(:each) do
    @project = FactoryGirl.create(:project, name: "Design")
    @project2 = FactoryGirl.create(:project, name: "Development")
    assign(:projects, [@project,
      @project2
    ])
    assign(:percentages, {@project.id => 50, @project2.id => 34})
    allow(view).to receive(:will_paginate).and_return true
  end

  it "renders a link to create a new project" do
    render
    expect(rendered).to have_link("Create Project")
  end

  it "displays project completion percentages" do
    render
    expect(rendered).to match /50%/
    expect(rendered).to match /34%/
  end

  it "displays project names" do
    render
    expect(rendered).to match /Design/
    expect(rendered).to match /Development/
  end

  it "displays all sublinks" do
    render
    expect(rendered).to have_link("Design")
    expect(rendered).to have_link("Development")
  end
end
