require "reputation_helper"

class AnswersController < ApplicationController
  include ReputationHelper
  before_filter :get_question_and_user, :except => [:vote,:markanswer]
  
  # GET /questions/1/answers
  # GET /questions/1/answers.json
  def index
    @answers = @question.answers
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @answers }
    end
  end

  # GET /questions/1/answers/1
  # GET /questions/1/answers/1.json
  def show
    @answer = @question.answers.find(params[:id])
    @commentable = @answer
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @answer }
    end
  end

  # GET /questions/1/answers/new
  # GET /questions/1/answers/new.json
  def new
    @answer = @question.answers.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @answer }
    end
  end

  # GET /questions/1/answers/1/edit
  # GET /questions/1/answers/1/edit.json
  def edit
    @answer = @question.answers.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @answer }
    end
  end

  # POST /questions/1/answers
  # POST /questions/1/answers.json
  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        track_answer_activity_create @answer
        # points_for_answering current_user
        format.html { redirect_to [@question], notice: 'Answer was successfully added.' }
        format.json { render json: @answer, status: :created, location: @answer }
      else
        format.html { render action: "new" }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1/answers/1
  # PUT /questions/1/answers/1.json
  def update
    @answer = @question.answers.find(params[:id])
    respond_to do |format|
      if @answer.update_attributes(answer_params)
        track_answer_activity @answer
        format.html { redirect_to [@question,@answer], notice: 'Answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1/answers/1
  # DELETE /questions/1/answers/1.json
  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to @question }
      format.json { head :no_content }
    end
  end

  # POST /answers/1/vote
  def vote
    value = params[:type] == "up" ? 1 : -1
    @answer = Answer.find(params[:id])
    @answer.add_vote(value, current_user.id)
    @answer.up_votes_will_change!
    @answer.down_votes_will_change!
    @answer.save
    @votable = @answer
    render 'votes/vote'   
  end

  # POST /answers/1/markanswer
  def markanswer
    value = params[:type] == "mark" ? 1 : -1
    @answer = Answer.find(params[:id])
    if value == 1
      @answer.answer_mark = true
    else
      @answer.answer_mark = false
    end
    @answer.save
    track_answer_activity @answer
    @votable = @answer   
  end

  private

    def answer_params
      params.require(:answer).permit(:content)
    end

    def get_question_and_user
      @question = Question.find(params[:question_id])
      @user = current_user
    end

end
