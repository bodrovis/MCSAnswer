# frozen_string_literal: true

module GameActions
  class Base < ::ApplicationService
    def initialize(game)
      super
      @game = game
    end
  end
end
