# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  def show?
    record.topic.game.hosted_by? user
  end
end
