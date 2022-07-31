# frozen_string_literal: true

module Games
  class RecalculateService < ::ApplicationService
    def initialize(game)
      super
      @game = game
    end

    def call
      Game.transaction do
        all_teams = @game.playing_teams.order(total_answered: :desc).to_a

        all_teams.group_by(&:total_answered).each.with_index do |(_count, teams), index|
          teams.each { |team| team.place = (index + 1) }
        end

        PlayingTeam.import all_teams,
                           on_duplicate_key_update: { conflict_target: [:id], columns: %i[total_answered place] }
      end
    end
  end
end
