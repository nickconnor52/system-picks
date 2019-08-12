require 'rails_helper'

RSpec.describe Matchup, type: :model do
  let(:matchup_attributes) {
    {
      "home_team_score": 24,
      "away_team_score": 14,
    }
  }

  describe ".determine_outcome" do
    it "will determine that the system has correctly predicted a winner" do
      matchup = build(:matchup)
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

  describe ".team_covered" do
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

  describe ".calculate_system_pick" do
    it 'factories confirmed to work correctly with associated teams' do
      home_stats = build(:stat, :home_stats)
      away_stats = build(:stat, :away_stats)
      matchup = build(:matchup)

      expect(matchup.home_team_id).to eq(home_stats.team_id)
      expect(matchup.away_team_id).to eq(away_stats.team_id)
    end

    it 'will determine the system pick for a matchup' do
      create(:stat, :home_stats)
      create(:stat, :away_stats)
      matchup = build(:matchup)
      spread = matchup.calculate_system_pick()
      expect(spread).to eq(-4)
    end
  end
end
