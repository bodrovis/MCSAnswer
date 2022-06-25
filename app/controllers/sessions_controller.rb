# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy
  before_action :set_user, only: :create

  def new; end

  def create
    check = verify_captchas

    auth = @user&.authenticate(params[:password])

    if check && auth
      do_sign_in
    else
      flash.now[:warning] = t('recaptcha.errors.verification_failed') unless check
      flash.now[:warning] = t('.invalid_creds') if check && !auth
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = t '.success'
    redirect_to root_path, status: :see_other
  end

  private

  def set_user
    @user = User.find_by email: params[:email]
  end

  def verify_captchas
    verify_recaptcha(action: 'login', minimum_score: 0.7, secret_key: ENV.fetch('RECAPTCHA_SECRET_V3', nil)) ||
      verify_recaptcha(secret_key: ENV.fetch('RECAPTCHA_SECRET', nil))
  end

  def do_sign_in
    sign_in @user
    respond_to do |format|
      format.turbo_stream do
        flash[:success] = t('.success', name: current_user.name)
        @path = root_path
      end
    end
  end
end
