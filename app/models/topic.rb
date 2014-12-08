class Topic < ActiveRecord::Base

  class << self

    def followers_size(name)
      @tag = ActsAsTaggableOn::Tag.where(name: name).first
      @tag.followers.length
    end

    def find_famous_topics
      taggings =  ActsAsTaggableOn::Tagging.group('tag_id').order("count_all desc").limit(5).count("*")
      topics = Array.new

      taggings.each do|key,value|
        @tag = ActsAsTaggableOn::Tag.where(name: key).first
        topics.push({tagcount:value, name:@tag.name})
      end
      return topics
    end

    def find_leaders(topic)
      ids = $redis.zrevrange("rep:topic:" + topic.to_s, 0,4)
      @leaders = Array.new
      ids.each do |id|
        @user = User.find(id)
        # logger.debug "user is #{@user.attributes.inspect}"
        @leader  = Hash.new
        @leader[:id] = @user.id
        @leader[:name] = @user.name
        @leader[:photo]= @user.profile_picture.url(:little)
        @leader[:score] = $redis.zscore("rep:topic:" + topic,id).to_i
        topicname = topic.capitalize
        if @leader[:score] > 200
         @leader[:badge] = 'Guru'
        elsif @leader[:score] >100
          @leader[:badge] = 'Expert'
        elsif @leader[:score] >50
          @leader[:badge] = 'Proficient'
        else
          @leader[:badge] = 'Novice'
        end
        @leaders.push(@leader)
      end
      logger.debug "leaders size returned #{@leaders.size}"
      return @leaders
    end
  end
end
