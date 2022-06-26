class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :playing_team, null: false, foreign_key: true
      t.belongs_to :game, null: false, foreign_key: true
      t.text :body
      t.boolean :correct, null: false, default: false

      t.timestamps
    end

    add_index :answers, [:question_id, :playing_team_id], unique: true
    add_index :answers, [:game_id, :question_id, :playing_team_id], unique: true, name: 'index_xxx_on_game_id_and_question_id_and_team_game_id'
  end
end
