class NotificationsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  # GET /notifications/index.json
  def index
    @number = $redis.get "/messages/" + current_user.id.to_s + "/ncount" 
    respond_to do |format|
      format.json {render json: @number}
    end
  end

  # GET /notifications/show.json
  def show
    logger.debug "current_user #{current_user.id}"
    notification_count_pointer = "/messages/" + current_user.id.to_s + "/ncount"
    $redis.set notification_count_pointer , 0
    @number = $redis.get "/messages/" + current_user.id.to_s + "/ncount" 
    start = params[:page] ? page[:page] : 0
    ids = $redis.zrevrange("notification:" + current_user.id.to_s, start*10 ,start*10 + 9)
    logger.debug "Ids size are #{ids.size} and start #{start}"
    @activities = Activity.includes(:user).where(id: ids).order("updated_at DESC").limit(5)
    respond_to do |format|
      format.json do
        render :json => @activities.to_json({:methods => [:affected_name,:trackable_name],:include => { :user => { :only => :name, :methods => :profile_pic_url_medium } }})
      end
    end
  end

  # GET /notifications/showall.json
  def showall
    if current_user.notifications.length > 30
      ids = current_user.notifications[-30,-1]
    else
      ids = current_user.notifications
    end
    @activities_today = Activity.where(id: ids).today.latest_first
    @activities_week = Activity.where(id: ids).this_week.latest_first
    @activities_before_week = Activity.where(id: ids).before_this_week.latest_first
    @activities_array = Array.new
    @activities_array.push(@activities_today)
    @activities_array.push(@activities_week)
    @activities_array.push(@activities_before_week)
    respond_to do |format|
      format.html # showall.html.erb
    end
  end
end
