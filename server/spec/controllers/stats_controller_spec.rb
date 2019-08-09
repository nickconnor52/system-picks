require 'rails_helper'

RSpec.describe StatsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Matchup. As you add validations to Matchup, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      "team_id": @team.id,
      "season": "2018",
      "week": "1",
      "give_take_diff": "-2",
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
    @team = Team.new(name: "Bengals")
    @team.save!
  end

  describe "GET #index" do
    it "returns a success response" do
      # binding.pry
      Stat.create! valid_attributes
      get :index, params: {:team_id => @team.id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it 'returns populated data object based on team and week' do
      stat = Stat.create! valid_attributes
      post :show, params: {:team_id => @team.id, :season => "2018", :week => "1"}, session: valid_session

      jsonResponse = JSON.parse(response.body).first
      giveTake = jsonResponse["give_take_diff"]

      expect(giveTake).to eq(stat.give_take_diff)
    end
  end
end
