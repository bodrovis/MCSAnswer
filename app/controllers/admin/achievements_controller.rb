# frozen_string_literal: true

module Admin
  class AchievementsController < BaseController
    before_action :set_achievement!, only: %i[destroy show]
    before_action :authorize_achievement!
    after_action :verify_authorized

    def index
      @achievements = Achievement.order created_at: :desc
    end

    def new
      @achievement = Achievement.new
    end

    def create
      @achievement = Achievement.new achievement_params
      if @achievement.save
        respond_to do |format|
          format.turbo_stream { flash.now[:success] = t('.success') }
        end
      else
        render :new
      end
    end

    def show
      @teams = @achievement.teams
    end

    def destroy
      @achievement.destroy

      respond_to do |format|
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    end

    private

    def set_achievement!
      @achievement = Achievement.find params[:id]
    end

    def authorize_achievement!
      authorize(@achievement || Achievement)
    end

    def achievement_params
      params.require(:achievement).permit(:title, :description, :file_data)
    end
  end
end
