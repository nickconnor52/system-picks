# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190803030439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matchups", primary_key: "matchup_id", id: :text, default: -> { "nextval('matchup_id_seq'::regclass)" }, force: :cascade do |t|
    t.text "away_team_id"
    t.text "correct_pick"
    t.text "date"
    t.boolean "deleted_at"
    t.text "home_team_id"
    t.text "note"
    t.text "score.away_team"
    t.text "score.home_team"
    t.integer "season"
    t.text "system_spread"
    t.text "time"
    t.text "vegas_spread"
    t.integer "week"
    t.text "spread_history"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", primary_key: "schedule_id", id: :text, force: :cascade do |t|
    t.text "away_team.abbreviation"
    t.text "away_team.city"
    t.integer "away_team.api_id"
    t.text "away_team.name"
    t.text "date"
    t.text "delayed_or_postponed_reason"
    t.text "home_team.abbreviation"
    t.text "home_team.city"
    t.integer "home_team.api_id"
    t.text "home_team.name"
    t.integer "api_id"
    t.text "location"
    t.text "original_date"
    t.text "original_time"
    t.text "schedule_status"
    t.integer "season"
    t.text "time"
    t.integer "week"
  end

  create_table "stats", primary_key: "stat_id", id: :text, force: :cascade do |t|
    t.float "def_3rd_per"
    t.float "def_LOS_drive"
    t.float "def_pass_yds_game"
    t.float "def_pts_game"
    t.float "def_pts_rz"
    t.float "def_RZA_game"
    t.float "def_rush_yds_game"
    t.integer "give_take_diff"
    t.float "off_3rd_pct"
    t.float "off_LOS_drive"
    t.float "off_pass_yds_game"
    t.float "off_pts_game"
    t.float "off_pts_rz"
    t.float "off_RZA_game"
    t.float "off_rush_yds_game"
    t.integer "season"
    t.text "team_id", null: false
    t.integer "week"
  end

  create_table "teams", primary_key: "team_id", id: :text, default: -> { "nextval('team_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "bye_week"
    t.float "home_field_advantage"
    t.text "location"
    t.text "name"
    t.text "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "matchups", "teams", column: "away_team_id", primary_key: "team_id", name: "matchups_away_team_fkey"
  add_foreign_key "matchups", "teams", column: "home_team_id", primary_key: "team_id", name: "matchups_home_team_fkey"
  add_foreign_key "stats", "teams", primary_key: "team_id", name: "stats_team_fkey"
end
