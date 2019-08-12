FactoryBot.use_parent_strategy = false

FactoryBot.define do
  factory :matchup do
    # association :home_team, factory: [:team, :bengals], strategy: :create
    # association :away_team, factory: [:team, :browns], strategy: :create
    after(:build) do |matchup|
      # Home Team
      if Team.exists?(name: "Browns")
        team = Team.find_by(name: "Browns")
        matchup.home_team = team
        matchup.home_team_id = team.id
      else
        team = create(:team, :bengals)
        matchup.home_team = team
        matchup.home_team_id = team.id
      end

      # Away Team
      if Team.exists?(name: "Bengals")
        team = Team.find_by(name: "Bengals")
        matchup.away_team = team
        matchup.away_team_id = team.id
      else
        team = create(:team, :browns)
        matchup.away_team = team
        matchup.away_team_id = team.id
      end
    end

    home_team_score { "26" }
    away_team_score { "18" }
    system_spread { "-4" }
    vegas_spread { "-9.5" }
    season { "2019" }
    week { "16" }
    note { "Factory created matchup" }
    time { "1:00PM" }
    date { DateTime.now.strftime("%F") }
  end
end
