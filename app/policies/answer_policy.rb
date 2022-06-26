# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.in_game(record.game)&.captain? &&
      record.question.current? &&
      !record.question.answered? &&
      !record.game.finished?
  end

  def toggle?
    record.game.hosted_by?(user) ||
      user.admin_role?
  end

  def update?
    record.game.hosted_by?(user) ||
      user.admin_role?
  end
end
