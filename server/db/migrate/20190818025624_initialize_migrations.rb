class InitializeMigrations < ActiveRecord::Migration[5.1]
  def change
    unless table_exists? :matchups
      create_table "matchups", primary_key: "matchup_id", id: :text, default: -> { "nextval('matchup_id_seq'::regclass)" } do |t|
        t.text "away_team_id"
        t.text "correct_pick"
        t.text "date"
        t.text "home_team_id"
        t.text "note"
        t.text "away_team_score"
        t.text "home_team_score"
        t.integer "season"
        t.text "system_spread"
        t.text "time"
        t.text "vegas_spread"
        t.integer "week"
        t.text "spread_history"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.datetime "deleted_at"
      end
    end

    unless table_exists? :schedules
      create_table "schedules", primary_key: "schedule_id", id: :text do |t|
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
    end

    unless table_exists? :stats
      create_table "stats", primary_key: "stat_id", id: :text, default: -> { "nextval('stat_id_seq'::regclass)" } do |t|
        t.float "def_3rd_pct"
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
    end

    unless table_exists? :teams
      create_table "teams", primary_key: "team_id", id: :text, default: -> { "nextval('team_id_seq'::regclass)" } do |t|
        t.integer "bye_week"
        t.float "home_field_advantage"
        t.text "location"
        t.text "name"
        t.text "nickname"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless table_exists? :users
      create_table "users" do |t|
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    end

    unless foreign_key_exists?(:matchups, column: "away_team_id")
      add_foreign_key "matchups", "teams", column: "away_team_id", primary_key: "team_id", name: "matchups_away_team_fkey"
    end
    unless foreign_key_exists?(:matchups, column: "home_team_id")
      add_foreign_key "matchups", "teams", column: "home_team_id", primary_key: "team_id", name: "matchups_home_team_fkey"
    end
    unless foreign_key_exists?(:stats, :teams)
      add_foreign_key "stats", "teams", primary_key: "team_id", name: "stats_team_fkey"
    end
  end
end
