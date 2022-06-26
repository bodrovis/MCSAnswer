# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_26_200546) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "playing_team_id", null: false
    t.bigint "game_id", null: false
    t.text "body"
    t.boolean "correct", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "question_id", "playing_team_id"], name: "index_xxx_on_game_id_and_question_id_and_team_game_id", unique: true
    t.index ["game_id"], name: "index_answers_on_game_id"
    t.index ["playing_team_id"], name: "index_answers_on_playing_team_id"
    t.index ["question_id", "playing_team_id"], name: "index_answers_on_question_id_and_playing_team_id", unique: true
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "game_players", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "playing_team_id", null: false
    t.boolean "captain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playing_team_id"], name: "index_game_players_on_playing_team_id"
    t.index ["user_id", "playing_team_id", "captain"], name: "index_game_players_on_user_id_and_playing_team_id_and_captain", unique: true
    t.index ["user_id", "playing_team_id"], name: "index_game_players_on_user_id_and_playing_team_id", unique: true
    t.index ["user_id"], name: "index_game_players_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "starts_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "host_id", null: false
    t.boolean "finished", default: false, null: false
    t.index ["host_id"], name: "index_games_on_host_id"
  end

  create_table "playing_teams", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_answered", default: 0, null: false
    t.index ["game_id"], name: "index_playing_teams_on_game_id"
    t.index ["team_id", "game_id"], name: "index_playing_teams_on_team_id_and_game_id", unique: true
    t.index ["team_id"], name: "index_playing_teams_on_team_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "body"
    t.text "answer"
    t.boolean "answered", default: false, null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false
    t.boolean "current"
    t.index ["current"], name: "index_questions_on_current"
    t.index ["game_id"], name: "index_questions_on_game_id"
    t.index ["position", "game_id"], name: "index_questions_on_position_and_game_id", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gravatar_hash"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "answers", "games"
  add_foreign_key "answers", "playing_teams"
  add_foreign_key "answers", "questions"
  add_foreign_key "game_players", "playing_teams"
  add_foreign_key "game_players", "users"
  add_foreign_key "games", "users", column: "host_id"
  add_foreign_key "playing_teams", "games"
  add_foreign_key "playing_teams", "teams"
  add_foreign_key "questions", "games"
end
