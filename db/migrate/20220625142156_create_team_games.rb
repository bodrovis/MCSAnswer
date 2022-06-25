class CreateTeamGames < ActiveRecord::Migration[7.0]
  def change
    create_table :team_games do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end

    add_index :team_games, [:team_id, :game_id], unique: true
  end
end
