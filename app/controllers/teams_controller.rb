# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team!, only: :show

  def index
    @pagy, @teams = pagy Team.order(updated_at: :desc, title: :asc)
  end

  def show
    @pagy, @playing_teams = pagy @team.playing_teams
                                      .includes(:game, game_players: :user).game_published_finished
  end

  private

  def set_team!
    @team = Team.find params[:id]
  end
end
