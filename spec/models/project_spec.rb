require 'rails_helper'

describe Project do

	before(:each) do 
		@project = FactoryGirl.create(:project)
	end

  it "is invalid without a name" do
    @project = FactoryGirl.build(:project, :name => "")
    expect(@project).not_to be_valid
  end

  it "has a valid factory" do
    expect(@project).to be_valid
  end

  it "returns users after search" do
  	@user = FactoryGirl.create(:user)
  	@project.users << @user
  	@result = @project.find_users_by_name_like(@user.name)
  	expect(@result[0].id).to be @user.id

  end

  it "has a slug after creation" do
  	expect(@project.slug).not_to be_nil
  	expect(@project.slug).to include "randomproject"
  end

end
