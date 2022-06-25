module Admin
  class TeamGamesController < BaseController
    before_action :set_game!
    before_action :set_team_game!, only: %i[destroy]
    before_action :authorize_team_game!
    after_action :verify_authorized

    def new
      @team_game = @game.team_games.build
    end

    def create
      @team_game = @game.team_games.build team_game_params

      if @team_game.save
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
      @team_game.destroy

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
      @team_game = @game.team_games.find params[:id]
    end

    def authorize_team_game!
      authorize(@team_game || TeamGame)
    end

    def team_game_params
      params.require(:team_game).permit(:team_id)
    end
  end
end