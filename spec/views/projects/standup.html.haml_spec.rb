require 'rails_helper'

describe "projects/standup" do
  before(:each) do
    @project = FactoryGirl.create(:project, name: "design")
    @project.todo_lists.create(name: "List")
    assign(:project, @project)
    @user = FactoryGirl.create(:user, name: "srik")
    @todos = FactoryGirl.create_list(:todo,3, name: "important")
    assign(:open_todos, {@user => [@todos[0], @todos[1]]})
    assign(:closed_today, {@user => [@todos[0], @todos[1]]})
  end

  it "renders all side bar links" do
    render
    expect(rendered).to have_link("Dashboard")
    expect(rendered).to have_link("Users")
    expect(rendered).to have_link("Discussions")
    expect(rendered).to have_link("Standup Meeting")
    expect(rendered).to have_link("Documents")
  end

  it "renders todos" do
    render
    expect(rendered).to match /srik/
    expect(rendered).to match /important/
  end


end