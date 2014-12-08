require 'rails_helper'

describe CommentProcessingJob do
	describe "Comment for Question" do
	  it "should process the job successfully" do
	    CommentProcessingJob.extend(Module.new { def award_teamplayer id ; end ; def award_proactive_comments id, qid; end; def increase_notification_pointer i; end})
	  	@user = FactoryGirl.create(:user)
	  	@c_user = FactoryGirl.create(:user)
	  	@q_user = FactoryGirl.create(:user)
	  	@question = FactoryGirl.create(:question, user_id: @user.id)
	  	@question.followers.push @q_user
	  	@question.followers_will_change!
	  	@question.save
	  	@comment = FactoryGirl.create(:comment, commentable_id: @question.id, commentable_type: "Question")
	  	@activity = FactoryGirl.create(:activity, user_id: @c_user.id)
	  	CommentProcessingJob.perform @activity.id, @comment.id
	  	@user.reload
	  	@c_user.reload
	  	@q_user.reload
	  	expect(@user.notifications).to include @activity.id
	  	expect(@q_user.feed).to include @activity.id
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
	  	@user.reload
	  	@c_user.reload
	  	expect(@user.feed).to include @activity.id
	  	expect(@user.notifications).to include @activity.id
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
	  	@user.reload
	  	@c_user.reload
	  	expect(@user.notifications).to include @activity.id
	  	expect(@user.feed).to include @activity.id
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
	  	@discussion.followers.push @d_user
	  	@discussion.followers_will_change!
	  	@discussion.save
	  	@comment = FactoryGirl.create(:comment, commentable_id: @discussion.id, commentable_type: "Discussion")
	  	@activity = FactoryGirl.create(:activity, user_id: @a_user.id)
	  	CommentProcessingJob.perform @activity.id, @comment.id
	  	@user.reload
	  	@a_user.reload
	  	@p_user.reload
	  	@d_user.reload
	  	expect(@user.notifications).to include @activity.id
	  	expect(@p_user.feed).to include @activity.id
	  	expect(@d_user.notifications).to include @activity.id
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
	  	@todo.followers.push @t_user
	  	@todo.followers_will_change!
	  	@todo.save
	  	@comment = FactoryGirl.create(:comment, commentable_id: @todo.id, commentable_type: "Todo")
	  	@activity = FactoryGirl.create(:activity, user_id: @a_user.id)
	  	CommentProcessingJob.perform @activity.id, @comment.id
	  	@user.reload
	  	@a_user.reload
	  	@p_user.reload
	  	@t_user.reload
	  	expect(@user.notifications).to include @activity.id
	  	expect(@p_user.feed).to include @activity.id
	  	expect(@t_user.notifications).to include @activity.id
	  end
	end
end