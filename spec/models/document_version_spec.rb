require 'rails_helper'

describe DocumentVersion do

  it "has a valid factory" do
    @dv = FactoryGirl.build(:document_version)
    expect(@dv).to be_valid
  end

  it "is invalid with out file" do
    @dv = FactoryGirl.build(:document_version, file: nil)
    expect(@dv).not_to be_valid
  end
end
