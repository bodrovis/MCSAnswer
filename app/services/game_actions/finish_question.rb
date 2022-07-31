# frozen_string_literal: true

module GameActions
  class FinishQuestion < Base
    def call
      broadcast_later [@game, 'questions'],
                      'game_actions/finish',
                      locals: { game: @game }
    end
  end
end
