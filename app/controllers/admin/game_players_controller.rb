# frozen_string_literal: true

module Admin
  class GamePlayersController < BaseController
    before_action :set_game!
    before_action :set_team_game!
    before_action :set_game_player!, only: %i[edit update destroy]
    before_action :authorize_game_player!
    after_action :verify_authorized

    def new
      @game_player = @team_game.game_players.build
    end

    def create
      @game_player = @team_game.game_players.build game_player_params

      if @game_player.save
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = t('.success')
          end
        end
      else
        render :new
      end
    end

    def edit; end

    def update
      if @game_player.update game_player_params
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = t('.success')
          end
        end
      else
        render :edit
      end
    end

    def destroy
      @game_player.destroy

      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = t('.success')
        end
      end
    end

    private

    def set_game!
      @game = Game.find params[:game_id]
    end

    def set_team_game!
      @team_game = @game.team_games.find params[:team_game_id]
    end

    def set_game_player!
      @game_player = @team_game.game_players.find params[:id]
    end

    def authorize_game_player!
      authorize(@game_player || GamePlayer)
    end

    def game_player_params
      params.require(:game_player).permit(:user_id, :captain)
    end
  end
end
