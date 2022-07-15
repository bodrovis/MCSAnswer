# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :notfound
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    respond_to do |format|
      format.html do
        flash[:danger] = t 'global.flash.not_authorized'
        redirect_to(request.referer || root_path, status: :see_other)
      end
      format.turbo_stream { head(:forbidden) }
    end
  end

  def notfound(exception)
    logger.warn exception
    respond_to do |format|
      format.html { render file: 'public/404.html', status: :not_found, layout: false }
      format.turbo_stream { head(:not_found) }
    end
  end

  def current_user
    cookies.encrypted[:user_id].present? ? User.find_by(id: cookies.encrypted[:user_id]) : nil
  end

  def user_signed_in?
    current_user.present?
  end

  def require_authentication
    return if user_signed_in?

    flash[:warning] = t 'global.flash.not_signed_in'
    redirect_to root_path, status: :see_other
  end

  def require_no_authentication
    return unless user_signed_in?

    flash[:warning] = t 'global.flash.already_signed_in'
    redirect_to root_path, status: :see_other
  end

  def sign_in(user)
    cookies.encrypted[:user_id] = user.id
  end

  def sign_out
    cookies.delete :user_id
  end

  def broadcast(channel, template, **params)
    Turbo::StreamsChannel.broadcast_render_later_to(
      channel,
      template:,
      **params
    )
  end

  helper_method :current_user, :user_signed_in?
end
