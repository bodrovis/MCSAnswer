# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.text :body
      t.text :answer
      t.boolean :answered, default: false, null: false
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
