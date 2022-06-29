# frozen_string_literal: true

class AddQuestionEndsAtToGames < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/BulkChangeTable
    add_column :games, :question_ends_at, :datetime
    remove_column :games, :question_asked_at, :datetime
    # rubocop:enable Rails/BulkChangeTable
  end
end
