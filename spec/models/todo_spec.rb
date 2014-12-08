require 'rails_helper'

describe Todo do
 describe "creation" do

  it "has valid factory" do
      @todo = FactoryGirl.build(:todo)
      expect(@todo).to be_valid
    end

  context "create" do
    it "should not be created with out a name" do
      @todo = FactoryGirl.build(:todo, name: "")
      expect(@todo).not_to be_valid
    end

    it "should not be created with out details" do
      @todo = FactoryGirl.build(:todo, details: "")
      expect(@todo).not_to be_valid
    end

    it "should not be created with out target date" do
      @todo = FactoryGirl.build(:todo, target_date: "")
      expect(@todo).not_to be_valid
    end

    it "should not be created with out user" do
      @todo = FactoryGirl.build(:todo, user_id: "")
      expect(@todo).not_to be_valid
    end

     it "should not be created with out todo list" do
      @todo = FactoryGirl.build(:todo, todo_list_id: "")
      expect(@todo).not_to be_valid
    end

    it "has a slug after creation" do
      @todo = FactoryGirl.create(:todo)
      expect(@todo.slug).not_to be_nil
      expect(@todo.slug).to match /doit/i
    end
  end

  context "update" do
    before(:each) do
      @todo = FactoryGirl.create(:todo)
    end
    it "should not be updated with out a name" do
      @todo.update_attributes(name: "")
      expect(@todo).not_to be_valid
    end

    it "should not be updated with out details" do
      @todo.update_attributes(details: "")
      expect(@todo).not_to be_valid
    end

    it "should not be updated with out target date" do
      @todo.update_attributes(target_date: "")
      expect(@todo).not_to be_valid
    end

    it "should not be updated with out user" do
      @todo.update_attributes(user_id: "")
      expect(@todo).not_to be_valid
    end

    it "should not be updated with out todo list" do
      @todo.update_attributes(todo_list_id: "")
      expect(@todo).not_to be_valid
    end

  end

  context "states" do
    before(:each) do
      @todo = FactoryGirl.create(:todo)
    end
    it "should be open by default" do
      expect(@todo.open?).to be_truthy
    end

    it "should close" do
      @todo.close
      expect(@todo.closed?).to be_truthy
    end

    it "should reopen" do
      @todo.close
      @todo.reopen
      expect(@todo.open?).to be_truthy
    end
  end
end
end
