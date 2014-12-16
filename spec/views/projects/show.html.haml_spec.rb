require 'rails_helper'

describe "projects/show" do
  before(:each) do
    @project = FactoryGirl.create(:project, name: "design")
    @project.todo_lists.create(name: "List")
    @project = assign(:project, @project)
  end

  it "renders all side bar links" do
    render
    expect(rendered).to have_link("Dashboard")
    expect(rendered).to have_link("Users")
    expect(rendered).to have_link("Discussions")
    expect(rendered).to have_link("Standup Meeting")
    expect(rendered).to have_link("Documents")
  end

  it "renders project name" do
    render
    expect(rendered).to match /Design/
  end

  it "renders modal to create todo list form" do
    render
    expect(rendered).to match /todolist-modal/
  end

  it "renders link to todo lists" do
    render
    expect(rendered).to have_link("List")
    expect(rendered).to have_link("Open")
  end
end
