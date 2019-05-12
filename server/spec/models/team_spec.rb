require 'rails_helper'

RSpec.describe Team, type: :model do
  describe ".getAllTeams" do
    it 'returns all teams from database' do
      team_one = Team.create(name: 'Bengals')
      team_two = Team.create(name: 'Cowboys')

      result = Team.getAllTeams()

      expect(result).to eq [team_one, team_two]
    end
  end
end
