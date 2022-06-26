class AnswersController < ApplicationController
  before_action :require_authentication
  before_action :set_game!, except: :toggle
  before_action :set_question!, only: :create
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
    game = Game.find params[:game_id]
    @answer = game.answers.find params[:id]
    @team = @answer.playing_team
    @question = @answer.question

    authorize @answer

    @answer.toggle! :correct

    broadcast [game, :answers], 'answers/toggle'

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  private

  def set_game!
    @game = Game.find(params[:game_id])
  end

  def set_question!
    @question = @game.questions.find params[:question_id]
  end
end