# frozen_string_literal: true

class CreateAchievementOwnables < ActiveRecord::Migration[7.0]
  def change
    create_table :achievement_ownables do |t|
      t.belongs_to :achievement, null: false, foreign_key: true
      t.references :ownable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :achievement_ownables, %i[ownable_type ownable_id]
  end
end
