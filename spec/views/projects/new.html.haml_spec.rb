require 'rails_helper'

describe "projects/new" do
  before(:each) do
    assign(:project, FactoryGirl.build(:project))
  end

  it "renders new project form" do
    render
    expect(rendered).to match /Add a Project/
    expect(rendered).to match /Enter Project name/
    expect(rendered).to match /Enter Project description/
    expect(rendered).to match /Save Project/
  end

end
