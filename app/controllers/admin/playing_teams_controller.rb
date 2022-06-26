# frozen_string_literal: true

module Admin
  class PlayingTeamsController < BaseController
    before_action :set_game!
    before_action :set_playing_team!, only: %i[destroy]
    before_action :authorize_playing_team!
    after_action :verify_authorized

    def new
      @playing_team = @game.playing_teams.build
    end

    def create
      @playing_team = @game.playing_teams.build playing_team_params

      if @playing_team.save
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = t('.success')
          end
        end
      else
        render :new
      end
    end

    def destroy
      @playing_team.destroy

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

    def set_playing_team!
      @playing_team = @game.playing_teams.find params[:id]
    end

    def authorize_playing_team!
      authorize(@playing_team || PlayingTeam)
    end

    def playing_team_params
      params.require(:playing_team).permit(:team_id)
    end
  end
end
