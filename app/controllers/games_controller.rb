# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game!, except: :index
  before_action :authorize_game!
  after_action :verify_authorized

  def index
    @games = Game.includes(:host).order(created_at: :desc)
  end

  def show
    @game_player = current_user&.in_game(@game)
  end

  def recalculate
    Game.transaction do
      all_teams = @game.playing_teams.order(total_answered: :desc).to_a

      all_teams.group_by(&:total_answered).each.with_index do |(_count, teams), index|
        teams.each { |team| team.place = (index + 1) }
      end

      PlayingTeam.import all_teams,
                         on_duplicate_key_update: { conflict_target: [:id], columns: %i[total_answered place] }
    end

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
