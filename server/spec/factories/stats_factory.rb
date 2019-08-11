FactoryBot.define do
  factory :stat do
    trait :home_stats do
      after(:build) do |stat|
        if Team.exists?(name: "Bengals")
          stat.team_id = Team.find_by(name: "Bengals").id
        else
          team = create(:team, :bengals)
          stat.team_id = team.id
        end
      end

    end

    trait :away_stats do
      after(:build) do |stat|
        if Team.exists?(name: "Browns")
          stat.team_id = Team.find_by(name: "Browns").id
        else
          team = create(:team, :browns)
          stat.team_id = team.id
        end
      end
    end
  end
end
