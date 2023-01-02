# frozen_string_literal: true

class PagePolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user || GuestUser.new
  end

  def search?
    user.admin_role?
  end
end
