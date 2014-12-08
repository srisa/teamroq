class DiscussionProcessingJob
  extend JobsHelper
  @queue = :discussions
  @log = Logger.new 'log/resque.log'
  ####################################################
  # discussions should be notified in the project context only
  # i.e., post posted on project page should be visible to
  # project only.
  # user followers should not be able to view these posts.
  #
  ########################################################
  def self.perform(activity_id,discussion_id)
    @discussion = Discussion.find(discussion_id)
    activity = Activity.find(activity_id)
    activity_user_id = activity.user_id
    discussion_notify_util @discussion,activity_id,activity_user_id
  end
end