require 'rails_helper'

describe ProjectsHelper do
	before(:each) do
    @project = FactoryGirl.create(:project)
  end
  it "add users to project" do
  	a = Array.new
  	users = FactoryGirl.create_list(:user,3)
  	users.each do |user|
  		a.push(user.name + "-" + user.email)
  	end  	
  	user_list = a.join(",")
  	helper.add_users_to_project user_list, @project
  	expect(@project.users.count).to be(3)
  	expect(ProjectRole.count).to be(3)
  end

  it "when no users are present" do
  	helper.add_users_to_project "", @project.id
  	expect(ProjectRole.count).to be(0)
  end

  it "single user is given" do
  	user = FactoryGirl.create(:user)
  	user_list = user.name + "-" + user.email
  	helper.add_users_to_project user_list, @project
  	expect(@project.users.count).to be(1)
  end

  it "random users are given" do
  	user_list = "Tim jones-tim@jones.com"
  	helper.add_users_to_project user_list, @project
  	expect(@project.users.count).to be(0)
  end

  it "modify hash to use key name" do
  	p = FactoryGirl.create(:project, name: "town")
  	hash = { p => "narsapur"}
  	result = helper.modify_hash_to_use_key_name hash
  	expect(result["town"]).to eq("narsapur")
  end

  it "sum values in hash" do
  	hash = { a: 2 , b: 3}
  	result = helper.sum_values_in_hash hash
  	expect(result[:a]).to eq(2)
  	expect(result[:b]).to eq(5)
  end
  it "subtract hash" do
  	hash1 = { a: 2 , b: 3}
  	hash2 = { a: 1}
  	result = helper.subtract_hash hash1, hash2
  	expect(result[:a]).to eq(1)
  	expect(result[:b]).to eq(3)
  end
end
