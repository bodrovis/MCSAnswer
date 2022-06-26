class AddTotalAnsweredToPlayingTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :playing_teams, :total_answered, :integer, null: false, default: 0
  end
end
