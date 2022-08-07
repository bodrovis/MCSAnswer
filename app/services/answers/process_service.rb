# frozen_string_literal: true

module Answers
  class ProcessService < ::ApplicationService
    def initialize(question, game, answer_text, user)
      super
      @question = question
      @game = game
      @answer_text = answer_text
      @user = user
    end

    def call
      tx_and_commit do
        @team = @user.in_game(@game)&.playing_team
        @answer = @game.answers.build question: @question,
                                      playing_team: @team,
                                      body: @answer_text

        return unless Pundit.policy(@user, @answer).create?

        @answer.save
      end
    end

    private

    def post_call
      broadcast(
        [@game, :answers],
        'answers/toggle',
        locals: {
          question: @question,
          game: @game,
          team: @team,
          answer: @answer
        }
      )
    end
  end
end
