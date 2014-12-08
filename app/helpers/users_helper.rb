module UsersHelper
  
	def current_user?(user)
		self.current_user.id == user.id
	end

  def profile_pic_url_medium
    self.profile_picture.url(:medium)
  end

  def get_total_points
    self.points.sum(:value).to_i
  end

  def follows_question?(question)
    question.followers.include? self.id
  end

  def follows_todo?(todo)
    todo.followers.include? self.id
  end

  def follows_post?(post)
    post.followers.include? self.id
  end

  def follows_discussion?(discussion)
    discussion.followers.include? self.id
  end

  def follows_user?(user)
    user.followers.include? self.id
  end

  def follows_topic?(topic)
    topic.followers.include? self.id
  end

  def change_points(options)
    if Gioco::Core::TYPES
      type_id = options[:type]
      points  = options[:points]
    else
      points  = options
    end
    type      = (type_id) ? Type.find(type_id) : false

    if Gioco::Core::TYPES
      raise "Missing Type Identifier argument" if !type_id
      old_pontuation  = self.points.where(:type_id => type_id).sum(:value)
    else
      old_pontuation  = self.points.to_i
    end
    new_pontuation    = old_pontuation + points
    Gioco::Core.sync_resource_by_points(self, new_pontuation, type)
  end

  def next_badge?(type_id = false)
    type = (type_id) ? Type.find(type_id) : false
    if Gioco::Core::TYPES
      raise "Missing Type Identifier argument" if !type_id
      old_pontuation  = self.points.where(:type_id => type_id).sum(:value)
    else
      old_pontuation  = self.points.to_i
    end
    next_badge       = Badge.where("points > #{old_pontuation}").order("points ASC").first
    last_badge_point = self.badges.last.try('points')
    last_badge_point ||= 0

    if next_badge
      logger.debug "last badge point #{last_badge_point}  old_pontuation  #{old_pontuation}  next badge point #{next_badge.points}"
      percentage      = (old_pontuation - last_badge_point)*100/(next_badge.points - last_badge_point)
      points          = next_badge.points - old_pontuation
      next_badge_info = { 
                          :badge      => next_badge,
                          :points     => points,
                          :percentage => percentage
                        }
    end
  end

  def get_badges_no_duplicate_type
    all_badges = self.badges.order("id desc")
    badgeHash =  Hash.new
    all_badges.each do |badge|
      if badgeHash[badge.type_id].nil?
        badgeHash[badge.type_id] = badge        
      end
    end
    @badges = Array.new
    badgeHash.each do |key,value|
      @badges.push(value)
    end
    return @badges
  end

end
