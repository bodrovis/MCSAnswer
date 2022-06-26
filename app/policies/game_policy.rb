# frozen_string_literal: true

class GamePolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    true
  end

  def next_question?
    record.hosted_by?(user) &&
      !record.finished?
  end

  def start_question?
    record.hosted_by?(user) &&
      !record.finished?
  end

  def finish_question?
    record.hosted_by?(user) &&
      !record.finished?
  end

  def answer_question?
    record.hosted_by?(user) &&
      !record.finished?
  end

  def manage_questions?
    record.hosted_by?(user) || user.admin_role?
  end
end
