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
	end
end