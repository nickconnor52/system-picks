class Matchup < ApplicationRecord
  acts_as_paranoid
  belongs_to :away_team, :class_name => "Team"
  belongs_to :home_team, :class_name => "Team"

  def correct_pick?
    home_score = self.home_team_score.to_f
    away_score = self.away_team_score.to_f
    vegas_spread = self.vegas_spread.to_f
    system_spread = self.system_spread.to_f

    home_team_covered = team_covered?(home_score, away_score, vegas_spread)

    if home_team_covered
      return system_spread <= vegas_spread
    else
      return system_spread >= vegas_spread
    end
  end

  def team_covered?(team, opponent, spread)
    opponent.to_f - team.to_f < spread.to_f
  end
end
