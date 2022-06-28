# frozen_string_literal: true

class AddQuestionAskedAtToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :question_asked_at, :datetime
  end
end
