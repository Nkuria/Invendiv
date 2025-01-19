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

ActiveRecord::Schema[7.1].define(version: 2025_01_17_061322) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bets", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.bigint "odd_id"
    t.decimal "stake", precision: 10, scale: 2
    t.integer "outcome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_bets_on_game_id"
    t.index ["odd_id"], name: "index_bets_on_odd_id"
    t.index ["stake"], name: "index_bets_on_stake"
    t.index ["user_id"], name: "index_bets_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "home_team_id"
    t.bigint "away_team_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["status"], name: "index_games_on_status"
  end

  create_table "odds", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "team_id"
    t.decimal "value", precision: 5, scale: 2
    t.integer "outcome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_odds_on_game_id"
    t.index ["outcome"], name: "index_odds_on_outcome"
    t.index ["team_id"], name: "index_odds_on_team_id"
    t.index ["value"], name: "index_odds_on_value"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "surname"
    t.string "email"
    t.boolean "verified"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "balance", default: "0.0"
    t.index ["balance"], name: "index_users_on_balance"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name", "surname"], name: "index_users_on_first_name_and_surname"
    t.index ["verified"], name: "index_users_on_verified"
  end

  add_foreign_key "bets", "games"
  add_foreign_key "bets", "odds"
  add_foreign_key "bets", "users"
  add_foreign_key "games", "teams", column: "away_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "odds", "games"
  add_foreign_key "odds", "teams"
end
