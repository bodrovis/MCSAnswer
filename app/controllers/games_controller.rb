# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game!, except: :index
  before_action :authorize_game!
  after_action :verify_authorized

  def index
    @games = Game.published
  end

  def show
    @game_player = current_user&.in_game(@game)
  end

  def recalculate
    Games::RecalculateService.call(@game)

    redirect_to game_answers_path(game_id: @game), status: :see_other
  end

  private

  def set_game!
    @game = Game.find(params[:id])
  end

  def authorize_game!
    authorize(@game || Game)
  end
end
