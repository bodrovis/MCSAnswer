# frozen_string_literal: true

class CreateAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :achievements do |t|
      t.string :title
      t.text :file_data
      t.text :description

      t.timestamps
    end
  end
end
