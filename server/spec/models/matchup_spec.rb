require 'rails_helper'

RSpec.describe Matchup, type: :model do
  let(:matchup_attributes) {
    {
      "home_team_score": 24,
      "away_team_score": 14,
    }
  }

  describe ".determineOutcome" do
    it "will determine that the system has correctly predicted a winner" do
      matchup = Matchup.new(matchup_attributes)
      matchup.system_spread = "-5"
      matchup.vegas_spread = "-3"

      correct_pick = matchup.correct_pick?

      expect(correct_pick).to eq true
    end

    it "will determine a losing situation where system favored opponent" do
      matchup = Matchup.new(matchup_attributes)
      matchup.system_spread = "3"
      matchup.vegas_spread = "-3"

      correct_pick = matchup.correct_pick?

      expect(correct_pick).to eq false
    end

    it "system spread liked the underdog who won" do
      matchup = Matchup.new({
        "home_team_score": 20,
        "away_team_score": 24,
      })
      matchup.system_spread = "3"
      matchup.vegas_spread = "-3"

      correct_pick = matchup.correct_pick?

      expect(correct_pick).to eq true
    end

    it "equates a push to a winner" do
      matchup = Matchup.new({
        "home_team_score": 20,
        "away_team_score": 24,
      })
      matchup.system_spread = "-4"
      matchup.vegas_spread = "-4"

      correct_pick = matchup.correct_pick?

      expect(correct_pick).to eq true
    end

    it "determines that a tie with vegas on a winner is correct" do
      matchup = Matchup.new({
        "home_team_score": 20,
        "away_team_score": 24,
      })
      matchup.system_spread = "-3"
      matchup.vegas_spread = "-3"

      correct_pick = matchup.correct_pick?

      expect(correct_pick).to eq true
    end
  end

  describe ".teamCovered" do
    context "determines if a team covered a given spread given" do
      it "home team won and covered" do
      matchup = Matchup.new(matchup_attributes)
      spread = "-3"

      expect(matchup.team_covered?("24", "14", spread)).to eq true
     end

      it "home team won and didn't cover" do
        matchup = Matchup.new(matchup_attributes)
        spread = "-7"

        expect(matchup.team_covered?("14", "10", spread)).to eq false
      end

      it "home team lost and covered" do
        matchup = Matchup.new(matchup_attributes)
        spread = "+3.5"

        expect(matchup.team_covered?("10", "13", spread)).to eq true
      end

      it "home team lost and didn't cover" do
        matchup = Matchup.new(matchup_attributes)
        spread = "+3.5"

        expect(matchup.team_covered?("10", "17", spread)).to eq false
      end

      it "home team tied and didn't cover" do
        matchup = Matchup.new(matchup_attributes)
        spread = "-3.5"

        expect(matchup.team_covered?("10", "10", spread)).to eq false
      end

      it "home team tied and covered" do
        matchup = Matchup.new(matchup_attributes)
        spread = "+3.5"

        expect(matchup.team_covered?("10", "13", spread)).to eq true
      end

      it "home team pushed counts as no cover" do
        matchup = Matchup.new(matchup_attributes)
        spread = "+3"

        expect(matchup.team_covered?("10", "13", spread)).to eq false
      end
    end
  end
end
