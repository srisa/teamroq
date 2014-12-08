require 'rails_helper'

describe "answers/show" do
  before(:each) do
    @answer = FactoryGirl.create(:answer, content: "Myanswer")
    assign(:answer, @answer)
    assign(:question, FactoryGirl.create(:question, content: "Myquestion")) 
    assign(:commentable, @answer) 
  end

  it "shows the answer" do
    render
    expect(rendered).to match /Myanswer/
  end

  it "shows links" do
    render
    expect(rendered).to have_link("Edit")
    expect(rendered).to have_link("Back")
  end
end
