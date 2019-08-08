class ConvertScoreNameToExludeDot < ActiveRecord::Migration[5.1]
  def change
    rename_column :matchups, "score.home_team", :home_team_score
    rename_column :matchups, "score.away_team", :away_team_score
  end
end
