require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe MatchupsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Matchup. As you add validations to Matchup, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      "home_team_score": 24,
      "away_team_score": 14,
      "away_team_id": @away_team.id,
      "home_team_id": @home_team.id,
      "system_spread": "-17",
      "vegas_spread": "-13",
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MatchupsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before do
    @away_team = Team.new(name: "Browns")
    @away_team.save!
    @home_team = Team.new(name: "Bengals")
    @home_team.save!
  end

  describe "GET #index" do
    it "returns a success response" do
      Matchup.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it "returns a JSON object with all matchups" do
      matchup = Matchup.create! valid_attributes
      get :index, params: {}, session: valid_session

      jsonResponse = JSON.parse(response.body)
      fieldNames = matchup.attribute_names.push("away_team", "home_team")

      expect(jsonResponse.first.keys).to match_array(fieldNames)
    end

    it 'returns away team correctly populated' do
      matchup = Matchup.create! valid_attributes
      get :index, params: {}, session: valid_session

      jsonResponse = JSON.parse(response.body).first
      awayTeamId = jsonResponse["away_team_id"]

      expect(awayTeamId).to eq(matchup.away_team_id)
      expect(jsonResponse["away_team_score"]).to eq(matchup.away_team_score)
    end

    it 'returns full matchup model data for use' do
      matchup = Matchup.create! valid_attributes
      get :index, params: {}, session: valid_session

      jsonResponse = JSON.parse(response.body).first
      awayTeam = jsonResponse["away_team"]

      expect(awayTeam["name"]).to eq(matchup.away_team.name)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      matchup = Matchup.create! valid_attributes
      get :show, params: {id: matchup.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      matchup = Matchup.create! valid_attributes
      get :edit, params: {id: matchup.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    it "updates a chosen matchup record" do
      matchup = Matchup.create! valid_attributes
      params = {
        home_team_score: "52",
      }
      put :update, params: { id: matchup.id, matchup: params }
      matchup.reload
      expect(response).to be_successful
      expect(matchup.home_team_score).to eq("52")
    end

    it "updates correct_pick if score is updated" do
      matchup = Matchup.create! valid_attributes.merge({correct_pick: "false"})
      params = {
        home_team_score: "52",
      }
      put :update, params: { id: matchup.id, matchup: params }
      matchup.reload
      expect(matchup.correct_pick).to eq("true")
    end
  end
end
