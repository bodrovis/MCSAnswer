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

  private

  def set_game!
    @game = Game.includes(:questions).find(params[:id])
  end

  def authorize_game!
    authorize(@game || Game)
  end
end
