# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: %i[edit update]
  before_action :set_user!, only: %i[edit update show]
  before_action :paginate_tournaments, only: %i[show update]
  before_action :authorize_user!
  after_action :verify_authorized

  def index
    @users = User.played_at_least_once
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params

    if verify_captchas && @user.save
      sign_in @user
      respond_to do |format|
        format.turbo_stream do
          flash[:success] = t('.success', name: current_user.name)
          @path = root_path
        end
      end
    else
      @user.validate
      render :new
    end
  end

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
    @user = User.find params[:id]
  end

  def paginate_tournaments
    @pagy, @playing_teams = pagy @user.playing_teams.includes(:game, :team, game_players: :user).game_published_finished
  end

  def verify_captchas
    true
    # (verify_recaptcha action: 'signup', minimum_score: 0.6,
    #                   secret_key: ENV.fetch('RECAPTCHA_SECRET_V3', nil)) ||
    #   (verify_recaptcha model: @user, secret_key: ENV.fetch('RECAPTCHA_SECRET', nil))
  end
end
