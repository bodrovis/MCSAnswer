# frozen_string_literal: true

module GameActions
  class AnswerQuestion < Base
    def call
      @current_question = @game.current_question
      @current_question.update answered: true

      post_call
    end

    private

    def post_call
      broadcast_later [@game, 'questions'],
                      'game_actions/answer',
                      locals: { current_question: @current_question, game: @game }
    end
  end
end
