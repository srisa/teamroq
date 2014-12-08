class PostProcessingJob
	@queue = :posts
	@logger = Logger.new 'log/resque.log'
	####################################################
	# Posts should be notified in the postable context only
	# i.e., post posted on project page should be visible to
	# project only.
	# user followers should not be able to view these posts.
	#
	########################################################
	def self.perform(activity_id,post_id)
	  @post = Post.find(post_id)
	  @postable = @post.postable
	  if @postable.is_a? User  	
	  	followers = User.find(@post.followers)
	  	followers.each do |user|
     		user.add_to_feed activity_id
     		user.save
    	end
	  elsif @post.postable.respond_to? :users
	  	@post.postable.users.each do |user|
			  user.add_to_feed activity_id
			  user.save
			end
	  end

	# Notify the tagged users
	# @postContent = @post.content
    # @tagsColl = @postContent.scan(/(@)\[\[(\d+):([\w\s\.\-]+):([\w\s@\.,-\/#!$%\^&\*;:{}=\-_`~()]+)\]\]/)
    #           .collect { |trigger, id, type, name| 
    #             { :trigger => trigger, :id => id, :type => type, :name => name }}
    # @tagsColl.each do |tag| 
    #   #here notification trigger logic user id can be retrieved by tag[:id]
    #   #logger.debug "Mentioned name: #{tag[:name]} and id: #{tag[:id]}"
    #   $redis.zadd("notification:" + tag[:id].to_s, Time.now.to_i, activity_id)
    #   notification_count_pointer = "/messages/" + tag[:id] + "/ncount"
    #   $redis.incr(notification_count_pointer)
    #   notification_count = $redis.get(notification_count_pointer)
    #   hex = Digest::SHA256.hexdigest(notification_count_pointer)[1,12]

    #   PrivatePub.publish_to("/messages/#{hex}",:message => notification_count )
    # end
	end
end