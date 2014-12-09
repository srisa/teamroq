module ReputationHelper

	def points_for_answering(user)
    @type = Type.find_by_name("Enlightened")
		logger.debug "Added #{POINTS_FOR_ANSWER} points to #{user.name} for type #{@type.name}"
    user.change_points({ points: POINTS_FOR_ANSWER, type: @type.id })
	end

  def points_for_commenting(user)
    @type = Type.find_by_name("Commenter")
    logger.debug "Added #{POINTS_FOR_COMMENT} points to #{user.name} for type #{@type.name}"
    user.change_points({ points: POINTS_FOR_COMMENT, type: @type.id })
  end

  def points_for_questioning(user)
    @type = Type.find_by_name("ProActive")
    logger.debug "Added #{POINTS_FOR_QUESTION} points to #{user.name} for type #{@type.name}"
    user.change_points({ points: POINTS_FOR_QUESTION, type: @type.id })        
  end

  def points_for_promoting(user)
    @type = Type.find_by_name("Promoter")
    logger.debug "Added #{POINTS_FOR_PROMOTING} points to #{user.name} for type #{@type.name}"
    user.change_points({ points: POINTS_FOR_PROMOTING, type: @type.id })        
  end

  def points_for_getting_promoted(user)
    @type = Type.find_by_name("Curious")
    logger.debug "Added two points to #{user.name} for type #{@type.name}"
    user.change_points({ points: 2, type: @type.id })        
  end

end