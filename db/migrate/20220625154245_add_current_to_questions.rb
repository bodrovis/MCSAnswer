# frozen_string_literal: true

class AddCurrentToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :current, :boolean, default: false, null: false
    add_index :questions, :current
  end
end
