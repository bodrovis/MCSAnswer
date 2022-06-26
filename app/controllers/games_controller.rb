# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game!, except: :index
  before_action :authorize_game!
  after_action :verify_authorized

  def index
    @games = Game.order(created_at: :desc)
  end

  def show
    @game_player = current_user&.in_game(@game)
  end

  def recalculate
    @game.playing_teams.find_each do |team|
      team.update total_answered: (team.answers.where(correct: true).count)
    end
    redirect_to game_answers_path(game_id: @game)
    # respond_to do |format|
    #   format.turbo_stream do
    #     @path = game_answers_path(game_id: @game)
    #   end
    # end
  end

  private

  def set_game!
    @game = Game.includes(:questions).find(params[:id])
  end

  def authorize_game!
    authorize(@game || Game)
  end
end
