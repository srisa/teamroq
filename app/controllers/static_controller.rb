class StaticController < ApplicationController
  skip_before_filter :authenticate_user!,:authenticate_tenant! 
  def index
    if user_signed_in?
      redirect_to activities_path 
      return
    end
    render :layout => false
  end

end