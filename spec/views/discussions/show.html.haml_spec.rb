require 'rails_helper'

describe "discussions/show" do
  before(:each) do
    allow(view).to receive(:current_user).and_return(FactoryGirl.create(:user))
    @project = FactoryGirl.create(:project, name: "Vennelo")
    @discussion = FactoryGirl.create(:discussion, title: "Important")
    @watchers = [FactoryGirl.create(:user, name: "Tim")]
    @followers_count = 23
    @commentable = @discussion
  end

  it "renders discussion" do
    render
    expect(rendered).to match(/Important/)
  end

  it "renders watchers" do
    render
    expect(rendered).to match(/Tim/)
    expect(rendered).to match(/followers_list/)
    expect(rendered).to have_button("Add Watchers")
  end

  it "renders followers" do
    render
    expect(rendered).to match(/23/)
  end
end
