require 'rails_helper'

describe GroupsHelper do

  before(:each) do
    @group = FactoryGirl.create(:group)
  end

  it "add users to group" do
  	a = Array.new
  	users = FactoryGirl.create_list(:user,3)
  	users.each do |user|
  		a.push(user.name + "-" + user.email)
  	end  	
  	user_list = a.join(",")
  	helper.add_users_to_group user_list, @group.id
  	expect(@group.users.count).to be(3)
  	expect(GroupRole.count).to be(3)
  end

  it "when no users are present" do
  	helper.add_users_to_group "", @group.id
  	expect(GroupRole.count).to be(0)
  end

  it "single user is given" do
  	user = FactoryGirl.create(:user)
  	user_list = user.name + "-" + user.email
  	helper.add_users_to_group user_list, @group.id
  	expect(@group.users.count).to be(1)
  end

  it "random users are given" do
  	user_list = "Tim jones-tim@jones.com"
  	helper.add_users_to_group user_list, @group.id
  	expect(@group.users.count).to be(0)
  end

end
