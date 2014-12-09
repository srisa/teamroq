require 'rails_helper'

describe CommentProcessingJob do
	describe "Comment for Question" do
	  it "should process the job successfully" do
	    CommentProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
	  	@user = FactoryGirl.create(:user)
	  	@c_user = FactoryGirl.create(:user)
	  	@q_user = FactoryGirl.create(:user)
	  	@question = FactoryGirl.create(:question, user_id: @user.id)
	  	$redis.sadd @question.followers_key, @q_user.id
	  	@comment = FactoryGirl.create(:comment, commentable_id: @question.id, commentable_type: "Question")
	  	@activity = FactoryGirl.create(:activity, user_id: @c_user.id)
	  	CommentProcessingJob.perform @activity.id, @comment.id
	  	expect(@user.notifications).to include @activity.id.to_s
	  	expect(@q_user.feed).to include @activity.id.to_s
	  end
	end

	describe "Comment for Answer" do
	  it "should process the job successfully" do
	    CommentProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
	  	@user = FactoryGirl.create(:user)
	  	@c_user = FactoryGirl.create(:user)
	  	@question = FactoryGirl.create(:question)
	  	@answer = FactoryGirl.create(:answer, user_id: @user.id)
	  	@comment = FactoryGirl.create(:comment, commentable_id: @answer.id, commentable_type: "Answer")
	  	@activity = FactoryGirl.create(:activity, user_id: @c_user.id)
	  	CommentProcessingJob.perform @activity.id, @comment.id
	  	expect(@user.feed).to include @activity.id.to_s
	  	expect(@user.notifications).to include @activity.id.to_s
	  end
	end

	describe "Comment for Post" do
	  it "should process the job successfully" do
	    CommentProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
	  	@user = FactoryGirl.create(:user)
	  	@c_user = FactoryGirl.create(:user)
	  	@post = FactoryGirl.create(:post, user_id: @user.id)
	  	@comment = FactoryGirl.create(:comment, commentable_id: @post.id, commentable_type: "Post")
	  	@activity = FactoryGirl.create(:activity, user_id: @c_user.id)
	  	CommentProcessingJob.perform @activity.id, @comment.id
	  	expect(@user.notifications).to include @activity.id.to_s
	  	expect(@user.feed).to include @activity.id.to_s
	  end
	end

	describe "Comment for Discussion" do
	  it "should process the job successfully" do
	    CommentProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
	  	@user = FactoryGirl.create(:user)
	  	@a_user = FactoryGirl.create(:user)
	  	@p_user = FactoryGirl.create(:user)
	  	@d_user = FactoryGirl.create(:user)
	  	@project = FactoryGirl.create(:project)
	  	@p_user.projects.push @project
	  	@discussion = FactoryGirl.create(:discussion, discussable_type: "Project", discussable_id: @project.id, user_id: @user.id)
	  	$redis.sadd @discussion.followers_key, @d_user.id
	  	@comment = FactoryGirl.create(:comment, commentable_id: @discussion.id, commentable_type: "Discussion")
	  	@activity = FactoryGirl.create(:activity, user_id: @a_user.id)
	  	CommentProcessingJob.perform @activity.id, @comment.id
	  	expect(@user.notifications).to include @activity.id.to_s
	  	expect(@p_user.feed).to include @activity.id.to_s
	  	expect(@d_user.notifications).to include @activity.id.to_s
	  end
	end

	describe "Comment for Todo" do
	  it "should process the job successfully" do
	    CommentProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
	  	@user = FactoryGirl.create(:user)
	  	@a_user = FactoryGirl.create(:user)
	  	@p_user = FactoryGirl.create(:user)
	  	@t_user = FactoryGirl.create(:user)
	  	@project = FactoryGirl.create(:project)
	  	@p_user.projects.push @project
	  	@list = FactoryGirl.create(:todo_list, project_id: @project.id)
	  	@todo = FactoryGirl.create(:todo, todo_list_id: @list.id, user_id: @user.id)
	  	$redis.sadd @todo.followers_key, @t_user.id
	  	@comment = FactoryGirl.create(:comment, commentable_id: @todo.id, commentable_type: "Todo")
	  	@activity = FactoryGirl.create(:activity, user_id: @a_user.id)
	  	CommentProcessingJob.perform @activity.id, @comment.id
	  	expect(@user.notifications).to include @activity.id.to_s
	  	expect(@p_user.feed).to include @activity.id.to_s
	  	expect(@t_user.notifications).to include @activity.id.to_s
	  end
	end
end