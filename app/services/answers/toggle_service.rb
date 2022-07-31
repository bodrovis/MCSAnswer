# frozen_string_literal: true

module Answers
  class ToggleService < ::ApplicationService
    def initialize(game, answer, user)
      super
      @game = game
      @answer = answer
      @user = user
    end

    def call
      current_state = @answer.correct?
      @team = @answer.playing_team

      Answer.transaction do
        @answer.update(correct: !current_state)
        # rubocop:disable Rails/SkipsModelValidations
        @answer.correct? ? @team.increment!(:total_answered) : @team.decrement!(:total_answered)
        # rubocop:enable Rails/SkipsModelValidations
      end

      post_call
    end

    private

    def post_call
      broadcast_later [@game, :answers], 'answers/toggle', locals: {
        game: @game,
        answer: @answer,
        team: @team,
        question: @answer.question
      }
    end
  end
end
