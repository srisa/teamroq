require 'rails_helper'

describe Group do
  before(:each) do 
		@group = FactoryGirl.create(:group)
	end

  it "is invalid without a name" do
    @group = FactoryGirl.build(:group, :name => "")
    expect(@group).not_to be_valid
  end

  it "has a valid factory" do
    expect(@group).to be_valid
  end


  it "slug is updated" do
  	@group.update_attributes(name: "pseudo")
  	result = Group.search("pseudo")
  	expect(result[0]["name"]).to match /pseudo/i
  end

  it "returns users after search" do
  	@user = FactoryGirl.create(:user)
  	@group.users << @user
  	@result = @group.find_users_by_name_like(@user.name)
  	expect(@result[0].id).to be @user.id

  end

  it "has a slug after creation" do
  	expect(@group.slug).not_to be_nil
  	expect(@group.slug).to match /group/i
  end
end
