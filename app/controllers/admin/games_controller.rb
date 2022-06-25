# frozen_string_literal: true

module Admin
  class GamesController < BaseController
    before_action :set_game!, only: %i[destroy show edit update]
    before_action :authorize_game!
    after_action :verify_authorized

    def index
      @games = Game.order created_at: :desc
    end

    def new
      @game = Game.new
    end

    def create
      @game = Game.new game_params

      if @game.save
        flash[:success] = t('.success')
        redirect_to admin_game_path(@game)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @game.update game_params
        flash[:success] = t('.success')
        redirect_to admin_games_path
      else
        render :edit
      end
    end

    def destroy
      @game.destroy

      respond_to do |format|
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    end

    private

    def set_game!
      @game = Game.find params[:id]
    end

    def game_params
      params.require(:game).permit(:title, :description, :starts_at, :host_id, :finished)
    end

    def authorize_game!
      authorize(@game || Game)
    end
  end
end
