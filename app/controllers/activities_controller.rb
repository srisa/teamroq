class ActivitiesController < ApplicationController
  respond_to :html, :json, :js

  def index
    page = params[:page] ? params[:page] : 1 
    ids = $redis.zrevrange(current_user.feed_key, (page - 1)*10 ,(page - 1)*10 + 9)   
    @activities = Activity.includes([:user,:trackable ]).where(id: ids).order("updated_at DESC")
    @number = $redis.get(current_user.notification_pointer)
    @more_results = has_more(ids.length)
    respond_with(@activities)
  end
 
  private

    def has_more(size)
      if(size<10)
        return false
      else
        return true
      end
    end

end
