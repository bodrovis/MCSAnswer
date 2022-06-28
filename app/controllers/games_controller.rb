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
      @game.playing_teams.find_each do |team|
        team.update total_answered: team.answers.where(correct: true).count
      end

      @game.playing_teams.order(total_answered: :desc).group_by(&:total_answered)
           .each.with_index do |(_count, teams), index|
        teams.each { |team| team.update(place: (index + 1)) }
      end
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
