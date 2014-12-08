require 'rails_helper'

describe Discussion do
  let (:discussion) {FactoryGirl.build(:discussion)}

  it "should have valid factory" do
  	expect(discussion).to be_valid
  end

  context "invalid cases " do
  	it "with out content" do
  		@discussion = FactoryGirl.build(:discussion, content: nil)
      expect(@discussion).not_to be_valid
    end

    it "with out title" do
      @discussion = FactoryGirl.build(:discussion, title: nil)
      expect(@discussion).not_to be_valid
    end
  end
end
