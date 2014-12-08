require 'rails_helper'

describe "answers/edit" do
  before(:each) do
    assign(:answer, FactoryGirl.create(:answer, content: "Myquestion"))
    assign(:question, FactoryGirl.create(:question, content: "Myanswer")) 
  end

  it "renders the edit answer form" do
    render
    expect(rendered).to match /Myquestion/
    expect(rendered).to match /Myanswer/
  end
end
