# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :set_user!, only: :destroy
    before_action :authorize_user!
    after_action :verify_authorized

    def index
      @users = User.order created_at: :desc
    end

    def destroy
      @user.destroy

      respond_to do |format|
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    end

    private

    def set_user!
      @user = User.find params[:id]
    end

    def authorize_user!
      authorize(@user || User)
    end
  end
end
