# frozen_string_literal: true

module Answers
  class UpdateService < ::ApplicationService
    def initialize(answer, game, answer_params)
      super
      @object = answer
      @game = game
      @answer_params = answer_params
    end

    def call
      tx_and_commit do
        @object.update(@answer_params)
      end

      super
    end

    private

    def post_call
      broadcast_later [@game, :answers], 'answers/toggle', locals: {
        game: @game,
        answer: @object,
        team: @object.playing_team,
        question: @object.question
      }
    end
  end
end
