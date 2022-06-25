# frozen_string_literal: true

class AddFinishedToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :finished, :boolean, default: false, null: false
  end
end
