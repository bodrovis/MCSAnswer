# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :require_authentication, except: :index
  before_action :set_game!
  before_action :set_question!, only: :create
  before_action :set_answer!, only: %i[edit update]
  after_action :verify_authorized

  def index
    @questions = @game.questions.order(position: :asc)
    @playing_teams = @game.playing_teams.includes(:team).order(place: :asc, total_answered: :desc, 'teams.title': :asc)
    authorize Answer
  end

  def create
    @answer = Answer.find_or_initialize_by question: @question,
                                           playing_team: current_user.in_game(@game)&.playing_team,
                                           game: @game

    authorize @answer

    @answer.body = params[:answer]

    @answer.save!

    @team = @answer.playing_team
    broadcast [@game, :answers], 'answers/toggle'

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def toggle
    @answer = @game.answers.find params[:id]
    @team = @answer.playing_team
    @question = @answer.question

    authorize @answer
    Answer.transaction do
      # rubocop:disable Rails/SkipsModelValidations
      @answer.toggle! :correct
      @answer.correct? ? @team.increment!(:total_answered) : @team.decrement!(:total_answered)
      # rubocop:enable Rails/SkipsModelValidations
    end

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
