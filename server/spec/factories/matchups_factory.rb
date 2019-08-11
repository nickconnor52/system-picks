FactoryBot.use_parent_strategy = false

FactoryBot.define do
  factory :matchup do
    association :home_team, factory: [:team, :bengals], strategy: :create
    association :away_team, factory: [:team, :browns], strategy: :create
    home_team_score { "24" }
    away_team_score { "14" }
    home_team_id { home_team.id }
    away_team_id { away_team.id }
    system_spread { "-7" }
    vegas_spread { "-3" }
    season { "2019" }
    week { "1" }
    note { "Factory created matchup" }
    time { "1:00PM" }
    date { DateTime.now.strftime("%F") }
  end
end
