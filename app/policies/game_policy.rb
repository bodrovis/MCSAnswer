# frozen_string_literal: true

class GamePolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    true
  end

  def next_question?
    record.hosted_by?(user)
  end

  def finish_question?
    record.hosted_by?(user)
  end
end
