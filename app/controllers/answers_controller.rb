# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :require_authentication, except: :index
  before_action :set_game!
  before_action :set_question!, only: :create
  before_action :set_answer!, only: %i[edit update]

  def index
    @questions = @game.questions.order(position: :asc)
    @playing_teams = @game.participating_teams
    authorize @game, :index_answers?
  end

  def create
    ProcessAnswerJob.perform_later @question, @game, params[:answer], current_user

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def toggle
    @answer = @game.answers.find params[:id]
    authorize @answer

    Answers::ToggleService.call @game, @answer, current_user

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def edit
    authorize @answer
  end

  def update
    authorize @answer

    success, @answer = Answers::UpdateService.call(@answer, @game, answer_params)

    if success
      respond_to do |format|
        format.turbo_stream { head(:ok) }
      end
    else
      render :edit
    end
  end

  private

  def set_answer!
    @answer = @game.answers.find params[:id]
  end

  def set_game!
    @game = Game.find(params[:game_id])
  end

  def set_question!
    @question = @game.questions.find params[:question_id]
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
