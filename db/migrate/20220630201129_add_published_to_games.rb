# frozen_string_literal: true

class AddPublishedToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :published, :boolean, default: false, null: false
    add_index :games, :published
  end
end
