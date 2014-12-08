require 'rails_helper'

describe TodoList do
  before(:each) do
    @todo_list = FactoryGirl.build(:todo_list) 
  end

  it "has valid factory" do
    expect(@todo_list).to be_valid
  end

  it "is not valid with out name" do
    @todo_list = FactoryGirl.build(:todo_list, name: "")
    expect(@todo_list).not_to be_valid
  end
end
