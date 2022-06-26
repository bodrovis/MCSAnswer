# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :require_authentication
  before_action :set_game!
  before_action :set_question!, only: :create
  before_action :set_answer!, only: %i[edit update]
  after_action :verify_authorized

  def index
    @questions = @game.questions.includes(answers: :playing_team).order(position: :asc)
    @playing_teams = @game.playing_teams.joins(:team).order('teams.title ASC')
    authorize Answer
  end

  def create
    @answer = Answer.new question: @question,
                         playing_team: current_user.in_game(@game)&.playing_team,
                         game: @game,
                         body: params[:answer]

    authorize @answer

    @answer.save!

    @team = @answer.playing_team
    broadcast [@game, :answers], 'answers/toggle'
  end

  def toggle
    @answer = @game.answers.find params[:id]
    @team = @answer.playing_team
    @question = @answer.question

    authorize @answer

    @answer.toggle! :correct # rubocop:disable Rails/SkipsModelValidations

    broadcast [@game, :answers], 'answers/toggle'

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def edit
    authorize @answer
  end

  def update
    authorize @answer

    if @answer.update answer_params
      @team = @answer.playing_team
      @question = @answer.question

      broadcast [@game, :answers], 'answers/toggle'

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
