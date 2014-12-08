class ActivitiesController < ApplicationController
  respond_to :html, :json, :js

  def index
    page = params[:page] ? params[:page] : 1
    feed_size = current_user.feed.length
    start_item = (page.to_i-1)*10 
    end_item = feed_size < (start_item + 10) ? feed_size : (start_item + 10)    
    ids = current_user.feed[start_item..end_item]   
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
