require 'rails_helper'
require 'will_paginate/array'

describe "projects/documents" do
  before(:each) do
    @project = FactoryGirl.create(:project, name: "design")
    @document = FactoryGirl.create(:document, name: "Vennelo")
    @project.documents.push @document
    @document_version = FactoryGirl.create(:document_version, document_id: @document.id)
    assign(:project, @project)
    assign(:documents, @project.documents.paginate(page: 1, per_page: 1))
    assign(:attachable, @project)
  end

  it "renders all side bar links" do
    render
    expect(rendered).to have_link("Dashboard")
    expect(rendered).to have_link("Users")
    expect(rendered).to have_link("Discussions")
    expect(rendered).to have_link("Standup Meeting")
    expect(rendered).to have_link("Documents")
  end

  it "renders all filters" do
    render
    expect(rendered).to have_link("UPDATED TODAY")
    expect(rendered).to have_link("MOST POPULAR")
    expect(rendered).to have_link("ADDED BY ME")
  end

  it "renders add document modal" do
    render
    expect(rendered).to match /#add-doc-modal/
  end

  it "renders documents" do
    render
    expect(rendered).to have_link("Vennelo")
    expect(rendered).to have_link("Previous Versions")
  end
end