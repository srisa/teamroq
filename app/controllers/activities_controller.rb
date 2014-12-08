class ActivitiesController < ApplicationController
  respond_to :html, :json, :js

  def index
    start = params[:page] ? params[:page] : 1
    startNew = -((start.to_i-1)*10 + 1)
    endNew = startNew - 9
    if current_user.feed.length > -endNew
      ids = current_user.feed[endNew..startNew]
    else
      ids = current_user.feed
    end
    @activities = Activity.includes([:user,:trackable ]).where(id: ids).order("updated_at DESC")
    @number = $redis.get(current_user.id.to_s + ":n_count")
    size = @activities.size
    logger.debug "activities size returned is #{size}"
    @more_results = has_more(size)
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
