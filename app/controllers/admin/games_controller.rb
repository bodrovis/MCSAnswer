# frozen_string_literal: true

module Admin
  class GamesController < BaseController
    before_action :set_game!, only: %i[destroy show edit update reorder_questions]
    before_action :authorize_game!
    after_action :verify_authorized

    def index
      @games = Game.includes(:host).order created_at: :desc
    end

    def new
      @game = Game.new
    end

    def create
      @game = Game.new game_params

      if @game.save
        flash[:success] = t('.success')
        redirect_to admin_game_path(@game), status: :see_other
      else
        render :new
      end
    end

    def reorder_questions
      @question = @game.questions.find_by position: params[:old_index]
      @question.insert_at params[:new_index]

      head :ok
    end

    def show; end

    def edit; end

    def update
      if @game.update game_params
        flash[:success] = t('.success')
        redirect_to admin_games_path, status: :see_other
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
      params.require(:game).permit(:title, :description, :starts_at, :host_id, :finished, :published)
    end

    def authorize_game!
      authorize(@game || Game)
    end
  end
end
