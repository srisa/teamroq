require 'rails_helper'

describe "projects/charts" do
  before(:each) do
    @project = FactoryGirl.create(:project, name: "design")
    @project.todo_lists.create(name: "List")
    assign(:project, @project)
    assign(:line_chart_series1,{"1"=> 2})
    assign(:line_chart_series2,{"1"=> 2})
    assign(:line_chart_series3,{"1"=> 2})
    assign(:data1,{"1"=>2})
    assign(:data2,{"1"=>2})
    assign(:delayed_users,{"1"=>2})
  end

  it "renders all side bar links" do
    render
    expect(rendered).to have_link("Dashboard")
    expect(rendered).to have_link("Users")
    expect(rendered).to have_link("Discussions")
    expect(rendered).to have_link("Standup Meeting")
    expect(rendered).to have_link("Documents")
    expect(rendered).to have_link("Charts")
  end

end