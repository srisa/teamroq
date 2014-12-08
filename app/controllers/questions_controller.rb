require 'will_paginate/array'
require "reputation_helper"

class QuestionsController < ApplicationController
  include ReputationHelper
  before_filter :get_user
  # GET /questions
  # GET /questions.json
  def index
    @tags = Question.topic_counts.paginate(page: params[:page], per_page: 12)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])
    @commentable = @question
    @followers_count = @question.followers.length    
    #@comment = Comment.new(:commentable_id => @question.id, :commentable_type => @question.class.name)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = @user.questions.build
    @question.topic_list = params[:topic]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = @user.questions.build(question_params)
    respond_to do |format|
      if @question.save
        track_question_activity_create @question
        # points_for_questioning @user
        format.html { redirect_to question_path(@question), notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(question_params)
        track_question_activity @question
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end

  # POST /questions/1/vote
  def vote
    value = params[:type] == "up" ? 1 : -1
    # points_for_promoting current_user
    @question = Question.find(params[:id])
    @owner = @question.user
    @question.add_vote(value, current_user.id)
    @question.up_votes_will_change!
    @question.down_votes_will_change!
    @question.save
    @votable = @question
    render 'votes/vote'
  end

  # GET /topics/:tag
  def topic
    @name = params[:tag]
    filter = params[:filter] || "top"
    @topic = ActsAsTaggableOn::Tag.where(name: @name).first
    @question_count = Question.find_questions_in_topic(@name).count
    @followers_count =  @topic.followers.count if @topic
    if filter == "top"
      @questions = Question.find_highest_voted_questions(@name).paginate(:page => params[:page], :per_page => 10)
    elsif filter == "unanswered"
      @questions = Question.find_unanswered_questions_in_topic(@name).paginate(:page => params[:page], :per_page => 10)
    elsif filter == "new"
      @questions = Question.find_latest_questions_in_topic(@name).paginate(:page => params[:page], :per_page => 10)
    elsif filter == "all"
      @questions = Question.find_questions_in_topic(@name).paginate(:page => params[:page], :per_page => 10)
    end
    @leaders = Topic.find_leaders(@name)
    render 'topics/topic'
  end

  private
    def question_params
      params.require(:question).permit(:title,:content,:topic_list)
    end
    def get_user
      @user = current_user
    end
end
