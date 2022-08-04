# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  def index?
    record.game.finished? && record.game.published?
  end
end