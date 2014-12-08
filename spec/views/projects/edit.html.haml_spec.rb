require 'rails_helper'

describe "projects/edit" do
  before(:each) do
    @project = FactoryGirl.create(:project, name: "design")
    assign(:project, @project)
  end


  it "renders the edit project form" do
    render
    expect(rendered).to match /project\[name\]/
    expect(rendered).to match /project\[description\]/
    expect(rendered).to have_button("Save Project")
  end
end
