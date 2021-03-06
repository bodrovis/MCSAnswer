# frozen_string_literal: true

class AddPositionToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :position, :integer, null: false, default: 1
    add_index :questions, %i[position game_id], unique: true
  end
end
