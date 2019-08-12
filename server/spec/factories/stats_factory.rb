FactoryBot.define do
  factory :stat do
    trait :away_stats do
      after(:build) do |stat|
        if Team.exists?(name: "Bengals")
          stat.team_id = Team.find_by(name: "Bengals").id
        else
          team = create(:team, :bengals)
          stat.team_id = team.id
        end
      end

      def_3rd_pct { 50.5 }
      def_LOS_drive { 28.61 }
      def_pass_yds_game { 270.6 }
      def_pts_game { 29.5 }
      def_pts_rz { 4.64 }
      def_RZA_game { 3.7 }
      def_rush_yds_game { 142.4 }
      give_take_diff { 0 }
      off_LOS_drive { 29.37 }
      off_3rd_pct { 38.9 }
      off_pass_yds_game { 222.3 }
      off_pts_game { 24.1 }
      off_pts_rz { 5.64 }
      off_RZA_game { 3 }
      off_rush_yds_game { 103.9 }
      season { "2019" }
      week { "16" }

    end

    trait :home_stats do
      after(:build) do |stat|
        if Team.exists?(name: "Browns")
          stat.team_id = Team.find_by(name: "Browns").id
        else
          team = create(:team, :browns)
          stat.team_id = team.id
        end
      end

      def_3rd_pct { 37.6 }
      def_LOS_drive { 28.91 }
      def_pass_yds_game { 275.1 }
      def_pts_game { 24.9 }
      def_pts_rz { 5.43 }
      def_RZA_game { 3.4 }
      def_rush_yds_game { 126.1 }
      give_take_diff { 9 }
      off_LOS_drive { 28.7 }
      off_3rd_pct { 34.6 }
      off_pass_yds_game { 234.6 }
      off_pts_game { 22.1 }
      off_pts_rz { 5.5 }
      off_RZA_game { 2.9 }
      off_rush_yds_game { 121.2 }
      season { "2019" }
      week { "16" }

    end
  end
end
