require 'rails_helper'

describe Document do
  let(:d) {FactoryGirl.build(:document)}
  before(:each) do 
  	@document = FactoryGirl.create(:document)
  end

  it "should have a valid factory" do
  	expect(d).to be_valid
  end

  it "is invalid with out name" do
    @document = FactoryGirl.build(:document, name: "")
    expect(@document).not_to be_valid
  end

end
