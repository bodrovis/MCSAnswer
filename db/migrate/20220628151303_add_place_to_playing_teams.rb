# frozen_string_literal: true

class AddPlaceToPlayingTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :playing_teams, :place, :integer
  end
end
