# frozen_string_literal: true

class AddHostIdToGames < ActiveRecord::Migration[7.0]
  def change
    add_reference :games, :host, null: false, foreign_key: { to_table: :users }, default: User.first
  end
end
