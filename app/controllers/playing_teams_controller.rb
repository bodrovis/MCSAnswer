# frozen_string_literal: true

class PlayingTeamsController < ApplicationController
  before_action :set_game!

  def index
    @playing_teams = @game.playing_teams.includes(:game_players, :team).order(created_at: :desc)
  end

  private

  def set_game!
    @game = Game.find params[:game_id]
  end
end
