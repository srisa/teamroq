class StaticController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    if user_signed_in?
      redirect_to activities_path 
      return
    end
    redirect_to new_user_session_path
  end

end