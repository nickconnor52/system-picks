class Matchup < ApplicationRecord
  acts_as_paranoid
  belongs_to :away_team, :class_name => "Team"
  belongs_to :home_team, :class_name => "Team"
end
