class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  protect_from_forgery

  before_filter  :authenticate_user!
  before_filter  :set_time_zone

  def set_time_zone
   Time.zone = current_user.time_zone if user_signed_in?   
  end 

  private

    def after_sign_up_path_for(resource)
      activities_path
    end

    def after_inactive_sign_up_path_for(resource)
      activities_path
    end
end
