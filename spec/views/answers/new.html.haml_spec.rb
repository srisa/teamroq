require 'rails_helper'

describe "answers/new" do
  before(:each) do
    assign(:answer, FactoryGirl.build(:answer))
    assign(:question, FactoryGirl.create(:question, content: "Myquestion")) 
  end

  it "renders the answer form" do
    render
    expect(rendered).to match /answer\[content\]/
    expect(rendered).to match /Myquestion/
    expect(rendered).to match /form/
  end
end
