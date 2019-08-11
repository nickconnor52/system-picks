FactoryBot.define do
  factory :matchup do
    home_team_score { "24" }
    away_team_score { "14" }
    system_spread { "-7" }
    vegas_spread { "-3" }
  end
end
