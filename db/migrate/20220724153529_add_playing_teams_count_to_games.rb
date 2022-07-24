class AddPlayingTeamsCountToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :playing_teams_count, :integer
  end
end
