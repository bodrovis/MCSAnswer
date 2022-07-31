# frozen_string_literal: true

module GameActions
  class StartQuestion < Base
    def call
      @game.update question_ends_at: 60.seconds.from_now

      post_call
    end

    private

    def post_call
      broadcast_later [@game, 'questions'],
                      'game_actions/start',
                      locals: { game: @game }
    end
  end
end
