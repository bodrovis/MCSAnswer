# frozen_string_literal: true

class AddQuestionsCountToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :questions_count, :integer
  end
end
