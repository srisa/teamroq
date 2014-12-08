require 'rails_helper'
include Warden::Test::Helpers

module FeatureHelpers
  def create_logged_in_user user
    user = FactoryGirl.create(:user)
    login(user)
    user
  end

  def login(user)
    login_as user, scope: :user
  end
end