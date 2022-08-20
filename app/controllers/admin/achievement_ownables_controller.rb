# frozen_string_literal: true

module Admin
  class AchievementOwnablesController < BaseController
    before_action :find_achievement!
    before_action :authorize_achievement_ownable!
    after_action :verify_authorized

    def new
      @achievement_ownable = @achievement.achievement_ownables.build
    end

    def create
      @achievement_ownable = @achievement.achievement_ownables.build achievement_ownable_params
      if @achievement_ownable.save
        respond_to do |format|
          format.turbo_stream { flash.now[:success] = t('.success') }
        end
      else
        render :new
      end
    end

    private

    def find_achievement!
      @achievement = Achievement.find params[:achievement_id]
    end

    def authorize_achievement_ownable!
      authorize(@achievement_ownable || AchievementOwnable)
    end

    def achievement_ownable_params
      params.require(:achievement_ownable).permit(:achievement_id, :ownable_type, :ownable_id)
    end
  end
end
