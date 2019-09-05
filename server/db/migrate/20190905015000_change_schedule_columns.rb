class ChangeScheduleColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :schedules, "away_team.abbreviation", :away_team_abbreviation
    rename_column :schedules, "away_team.city", :away_team_city
    rename_column :schedules, "away_team.api_id", :away_team_api_id
    rename_column :schedules, "away_team.name", :away_team_name
    rename_column :schedules, "home_team.abbreviation", :home_team_abbreviation
    rename_column :schedules, "home_team.city", :home_team_city
    rename_column :schedules, "home_team.api_id", :home_team_api_id
    rename_column :schedules, "home_team.name", :home_team_name
  end
end
