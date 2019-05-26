require "rails_helper"

RSpec.describe MatchupsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/api/matchups").to route_to("matchups#index")
    end

    it "routes to #new" do
      expect(:get => "/api/matchups/new").to route_to("matchups#new")
    end

    it "routes to #show" do
      expect(:get => "/api/matchups/1").to route_to("matchups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/api/matchups/1/edit").to route_to("matchups#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/api/matchups").to route_to("matchups#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/matchups/1").to route_to("matchups#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/matchups/1").to route_to("matchups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/matchups/1").to route_to("matchups#destroy", :id => "1")
    end
  end
end
