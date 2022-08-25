# frozen_string_literal: true

module Games
  class FillEmptyService < ::ApplicationService
    def initialize(game)
      super
      @game = game
    end

    def call
      tx_and_commit do
        answers = []
        @game.questions.each do |question|
          @game.playing_teams.each do |team|
            next if question.answered_by?(team)

            answers << @game.answers.build(question:, playing_team: team)
          end
        end

        Answer.import answers
      end
    end
  end
end
