# frozen_string_literal: true

class MakeQuestionPositionUniqueDeferrable < ActiveRecord::Migration[7.0]
  def up
    remove_index :questions, %i[position game_id], unique: true
    execute <<~SQL.squish
      alter table questions add constraint unique_game_id_position unique (game_id, position) deferrable initially deferred;
    SQL
  end

  def down
    execute <<~SQL.squish
      alter table questions drop constraint unique_game_id_position
    SQL
    add_index :questions, %i[position game_id], unique: true
  end
end
