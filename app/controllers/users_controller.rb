# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: %i[edit update]
  before_action :set_user!, only: %i[edit update show]
  before_action :authorize_user!
  after_action :verify_authorized

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.validate

    check = (verify_recaptcha action: 'signup', minimum_score: 0.6,
                              secret_key: ENV.fetch('RECAPTCHA_SECRET_V3', nil)) ||
            (verify_recaptcha model: @user, secret_key: ENV.fetch('RECAPTCHA_SECRET', nil))

    if check && @user.save
      sign_in @user
      respond_to do |format|
        format.turbo_stream do
          flash[:success] = t('.success', name: current_user.name)
          @path = root_path
        end
      end
    else
      render :new
    end
  end

  def index
    @users = User.where.not(games_played: 0).order(games_won: :desc)
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = t('.success')
        end
      end
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def authorize_user!
    authorize(@user || User)
  end

  def set_user!
    @user = User.includes(game_players: { playing_team: :game }).find params[:id]
  end
end
