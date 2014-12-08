require 'rails_helper'

describe ApplicationHelper do

	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

	describe "Activity creation" do
		before(:each) do
			@group = FactoryGirl.create(:group)
			@post = FactoryGirl.create(:post, postable_id: @group.id, postable_type: "Group")
		end

		it "creates an activity" do		
			helper.track_activity_create(@post, "create")
			expect(Activity.count).to eq(1)
		end

		it "queues a job" do
			helper.track_activity_create(@post, "create")
			expect(PostProcessingJob).to have_queued(Activity.last.id, @post.id).in(:posts) 
		end
	end

	describe "Update  activity" do
		before(:each) do
			@group = FactoryGirl.create(:group)
			@post = FactoryGirl.create(:post, postable_id: @group.id, postable_type: "Group")
		end

		it "queues a job" do
			a = Activity.create
			@post.activity = a
			helper.track_activity(@post, "edit")
			expect(PostProcessingJob).to have_queued(Activity.last.id, @post.id).in(:posts) 
		end
	end


	describe "Create Discussion activity" do
		before(:each) do
			@project = FactoryGirl.create(:project)
			@discussion = FactoryGirl.create(:discussion, discussable_id: @project.id, discussable_type: "Project")
		end

		it "creates an activity" do		
			helper.track_discussion_activity_create(@discussion, "create")
			expect(Activity.count).to eq(1)
		end

		it "queues a job" do
			helper.track_discussion_activity_create(@discussion, "create")
			expect(DiscussionProcessingJob).to have_queued(Activity.last.id, @discussion.id).in(:discussions) 
		end
	end

	describe "Update Discussion activity" do
		before(:each) do
			@project = FactoryGirl.create(:project)
			@discussion = FactoryGirl.create(:discussion, discussable_id: @project.id, discussable_type: "Project")
		end

		it "queues a job" do
			a = Activity.create
			@discussion.activity = a
			track_discussion_activity(@discussion, "edit")
			expect(DiscussionProcessingJob).to have_queued(Activity.last.id, @discussion.id).in(:discussions) 
		end

		it "updates the activity" do
			a = Activity.create
			@discussion.activity = a
			expect_any_instance_of(Activity).to receive(:update_attributes).with(action: "update")
			track_discussion_activity(@discussion, "update")
		end
	end

	# Answer Jobs
	describe "Create Answer Activity" do
		before(:each) do
			@question = FactoryGirl.create(:question)
			@answer = FactoryGirl.create(:answer, question_id: @question.id)
		end

		it "creates an activity" do
			helper.track_answer_activity_create(@answer,"create")
			expect(Activity.count).to eq(1)
		end

		it "queues answer job" do
			helper.track_answer_activity_create(@answer, "create")
			expect(AnswerProcessingJob).to have_queued(Activity.last.id, @answer.id).in(:answers) 
		end

		it "queues mark answers job" do
			helper.track_answer_activity_create(@answer, "mark")
			expect(MarkAnswerJob).to have_queued(Activity.last.id, @answer.id).in(:answers) 
		end
	end

	describe "update Answer Activity" do
		before(:each) do
			@question = FactoryGirl.create(:question)
			@answer = FactoryGirl.create(:answer, question_id: @question.id)
		end

		it "updates the activity" do
			a = Activity.create
			@answer.activity = a
			expect_any_instance_of(Activity).to receive(:update_attributes).with(action: "update")
			track_answer_activity(@answer, "update")
		end

		it "queues answer job" do
			a = Activity.create
			@answer.activity = a
			track_answer_activity(@answer, "update")
			expect(AnswerProcessingJob).to have_queued(Activity.last.id, @answer.id).in(:answers) 
		end

		it "queues answer job" do
			a = Activity.create
			@answer.activity = a
			track_answer_activity(@answer, "mark")
			expect(MarkAnswerJob).to have_queued(Activity.last.id, @answer.id).in(:answers)
		end
	end

	# Question Jobs

	describe "Create Question Activity" do
		before(:each) do
			@question = FactoryGirl.create(:question)
		end

		it "creates an activity" do
			helper.track_question_activity_create(@question,"create")
			expect(Activity.count).to eq(1)
		end

		it "queues question job" do
			helper.track_question_activity_create(@question, "create")
			expect(QuestionProcessingJob).to have_queued(Activity.last.id, @question.id).in(:questions) 
		end
	end

	describe "update Question Activity" do
		before(:each) do
			@question = FactoryGirl.create(:question)
		end

		it "updates the activity" do
			a = Activity.create
			@question.activity = a
			expect_any_instance_of(Activity).to receive(:update_attributes).with(action: "update")
			track_question_activity(@question, "update")
		end

		it "queues answer job" do
			a = Activity.create
			@question.activity = a
			track_question_activity(@question, "update")
			expect(QuestionProcessingJob).to have_queued(Activity.last.id, @question.id).in(:questions) 
		end
	end

	# Documents Jobs

	describe "Create Document Activity" do
		before(:each) do
			@document = FactoryGirl.create(:document)
		end

		it "creates an activity" do
			helper.track_document_activity_create(@document,"create")
			expect(Activity.count).to eq(1)
		end

		it "queues document job" do
			helper.track_document_activity_create(@document, "create")
			expect(DocumentProcessingJob).to have_queued(Activity.last.id, @document.id).in(:documents) 
		end
	end

	describe "update Document Activity" do
		before(:each) do
			@document = FactoryGirl.create(:document)
		end

		it "updates the activity" do
			a = Activity.create
			@document.activity = a
			expect_any_instance_of(Activity).to receive(:update_attributes).with(action: "update")
			track_document_activity(@document, "update")
		end

		it "queues answer job" do
			a = Activity.create
			@document.activity = a
			track_document_activity(@document, "update")
			expect(DocumentProcessingJob).to have_queued(Activity.last.id, @document.id).in(:documents) 
		end
	end

# TODO Jobs

	describe "Create Todo Activity" do
		before(:each) do
			@todo = FactoryGirl.create(:todo)
		end

		it "creates an activity" do
			helper.track_todo_activity(@todo,"create")
			expect(Activity.count).to eq(1)
		end

		it "queues todo job" do
			helper.track_todo_activity(@todo, "create")
			expect(TodoProcessingJob).to have_queued(Activity.last.id, @todo.id).in(:todos) 
		end
	end

	describe "Update Todo Activity" do
		before(:each) do
			@project = FactoryGirl.create(:project)
			@todo_list = FactoryGirl.create(:todo_list, project_id: @project.id)
			@todo = FactoryGirl.create(:todo, todo_list_id: @todo_list.id)
		end

		it "updates the activity" do
			a = Activity.create(action: "create")
			@todo.activities.push a
			expect_any_instance_of(Activity).to receive(:update_attributes).with(action: "update", user: @user)
			helper.track_todo_activity(@todo, "update")
		end

		it "queues todo job" do
			a = Activity.create(action: "create")
			@todo.activities.push a
			helper.track_todo_activity(@todo, "update")
			expect(TodoProcessingJob).to have_queued(Activity.last.id, @todo.id).in(:todos) 
		end

		describe "when activity is not present" do
			it "queues todo job on user change" do 
				a = Activity.create(action: "create")
				@todo.activities.push a
				helper.track_todo_activity_change_user(@todo, "user")
				expect(Activity.count).to eq(2)
				expect(TodoProcessingJob).to have_queued(Activity.last.id, @todo.id).in(:todos)
			end

			it "queues todo job on date change" do
				a = Activity.create(action: "create")
				@todo.activities.push a
				helper.track_todo_activity_change_date(@todo, "date")
				expect(Activity.count).to eq(2)
				expect(TodoProcessingJob).to have_queued(Activity.last.id, @todo.id).in(:todos)
			end
		end

		describe "when activity is present" do
			it "queues todo job on user change" do
				a = Activity.create(action: "user")
				@todo.activities.push a
				track_todo_activity_change_user(@todo, "user")
				expect(TodoProcessingJob).to have_queued(Activity.last.id, @todo.id).in(:todos) 
				expect(Activity.count).to eq(1) 
			end

			it "queues todo job on date change" do
				a = Activity.create(action: "date")
				@todo.activities.push a
				track_todo_activity_change_date(@todo, "date")
				expect(TodoProcessingJob).to have_queued(Activity.last.id, @todo.id).in(:todos) 
				expect(Activity.count).to eq(1) 
			end
		end
	end

	# Todo list jobs

	describe "Create Todo list Activity" do
		before(:each) do
			@project = FactoryGirl.create(:project)
			@todo_list = FactoryGirl.create(:todo_list, project_id: @project.id)
		end

		it "creates an activity" do
			helper.track_todo_list_activity_create(@todo_list,"create")
			expect(Activity.count).to eq(1)
		end

		it "queues Todo list job" do
			helper.track_todo_list_activity_create(@todo_list, "create")
			expect(TodoListProcessingJob).to have_queued(Activity.last.id, @todo_list.id).in(:todo_lists) 
		end
	end

	# Comment Jobs

	describe "Create Comment Activity For Non Todos" do
		before(:each) do
			@question = FactoryGirl.create(:question)
			@comment = FactoryGirl.create(:comment, commentable_id: @question.id, commentable_type: "Question")
			a = Activity.create(action: "create")
			@question.activity = a
		end


		it "queues comment job" do
			helper.track_comment_activity_create(@comment, "create")
			expect(CommentProcessingJob).to have_queued(Activity.last.id, @comment.id).in(:comments) 
		end
	end

	describe "Create Comment Activity For Todos" do
		before(:each) do
			@todo = FactoryGirl.create(:todo)
			@comment = FactoryGirl.create(:comment, commentable_id: @todo.id, commentable_type: "Todo")
			a = Activity.create(action: "create")
			@todo.activities.push a
		end

		it "create comment activity if it is not already present" do
			helper.track_comment_activity_create(@comment, "create")
			expect(Activity.count).to eq(2)
		end

		it "uses create comment activity if it is already present" do
			@todo.activities.push Activity.create(action: "comment")
			helper.track_comment_activity_create(@comment, "create")
			expect(Activity.count).to eq(2)
		end

		it "queues comment job" do
			helper.track_comment_activity_create(@comment, "create")
			expect(CommentProcessingJob).to have_queued(Activity.last.id, @comment.id).in(:comments) 
		end
	end


end