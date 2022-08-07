# frozen_string_literal: true

module GameActions
  class NextQuestion < Base
    def call
      tx_and_commit do
        current_question = @game.current_question
        current_question&.update current: false
        @next_question = @game.next_question current_question

        if @next_question.present?
          @next_question.update current: true
        else
          @game.update finished: true
        end
      end
    end

    private

    def post_call
      broadcast_later [@game, 'questions'],
                      'game_actions/next',
                      locals: { next_question: @next_question, game: @game }
    end
  end
end
