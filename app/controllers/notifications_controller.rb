class NotificationsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  # GET /notifications/index.json
  def index
    @number = $redis.get current_user.notification_pointer
    respond_to do |format|
      format.json {render json: @number}
    end
  end

  # GET /notifications/show.json
  def show
    $redis.set current_user.notification_pointer , 0
    @number = $redis.get current_user.notification_pointer
    start = params[:page] ? page[:page] : 0
    ids = $redis.zrevrange(current_user.notification_key, start*10 ,start*10 + 9)
    @activities = Activity.includes(:user).where(id: ids).order("updated_at DESC").limit(5)
    respond_to do |format|
      format.json do
        render :json => @activities.to_json({:methods => [:affected_name,:trackable_name],:include => { :user => { :only => :name, :methods => :profile_pic_url_medium } }})
      end
    end
  end

  # GET /notifications/showall.json
  def showall
    ids = $redis.zrevrange current_user.notification_key, 0, 30
    @activities = Activity.where(id: ids).latest_first
    respond_to do |format|
      format.html # showall.html.erb
    end
  end
end
