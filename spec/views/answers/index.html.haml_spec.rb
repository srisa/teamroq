require 'rails_helper'

describe "answers/index" do
  before(:each) do
    allow(view).to receive(:current_user).and_return(FactoryGirl.create(:user))
    assign(:answers, [FactoryGirl.create(:answer, content: "Myanswer")])
    assign(:question, FactoryGirl.create(:question))
  end
  
  it "renders a list of answers" do
    render
    expect(rendered).to match /Myanswer/
  end

  it "renders links buttons" do
    render
    expect(rendered).to have_button "Submit"
    expect(rendered).to have_link "New Answer"
  end
end
