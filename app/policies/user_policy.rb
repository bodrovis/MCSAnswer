# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def create?
    user.guest?
  end

  def update?
    record == user
  end

  def index?
    true
  end

  def show?
    true
  end

  def destroy?
    false
  end
end
