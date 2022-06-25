# frozen_string_literal: true

module Api
  class GamePolicy < ApplicationPolicy
    def alarm?
      record.hosted_by?(user)
    end

    def suggest_answer?
      !record.finished? &&
        record.participated_by?(user) &&
        record.current_question.present? &&
        !record.current_question.answered? &&
        record.game_players.current.blank? &&
        !record.game_players.find_by(player: user).answered?
    end

    def correct_answer?
      !record.finished? &&
        record.hosted_by?(user) &&
        record.current_question.present? &&
        !record.current_question.answered? &&
        record.game_players.current.present?
    end

    def incorrect_answer?
      !record.finished? &&
        record.hosted_by?(user) &&
        record.current_question.present? &&
        !record.current_question.answered? &&
        record.game_players.current.present?
    end

    def finish_question?
      !record.finished? &&
        record.hosted_by?(user) &&
        record.current_question.present? &&
        !record.current_question.answered?
    end
  end
end
