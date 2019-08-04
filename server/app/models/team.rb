class Team < ApplicationRecord
  def self.getAllTeams
    Team.all
  end
end
