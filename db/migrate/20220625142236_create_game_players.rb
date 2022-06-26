# frozen_string_literal: true

class CreateGamePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :game_players do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :playing_team, null: false, foreign_key: true
      t.boolean :captain

      t.timestamps
    end

    add_index :game_players, %i[user_id playing_team_id], unique: true
    add_index :game_players, %i[user_id playing_team_id captain], unique: true
  end
end
