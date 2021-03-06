# frozen_string_literal: true

class CreatePlayingTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :playing_teams do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end

    add_index :playing_teams, %i[team_id game_id], unique: true
  end
end
