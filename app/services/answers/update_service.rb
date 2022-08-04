# frozen_string_literal: true

module Answers
  class UpdateService < ::ApplicationService
    def initialize(answer, game, answer_params)
      super
      @answer = answer
      @game = game
      @answer_params = answer_params
    end

    def call
      @answer.update(@answer_params) && post_call
    end

    private

    def post_call
      broadcast_later [@game, :answers], 'answers/toggle', locals: {
        game: @game,
        answer: @answer,
        team: @answer.playing_team,
        question: @answer.question
      }
    end
  end
end