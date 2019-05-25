require "rails_helper"

RSpec.describe TeamsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/api/teams").to route_to("teams#index")
    end

    it "routes to #new" do
      expect(:get => "/api/teams/new").to route_to("teams#new")
    end

    it "routes to #show" do
      expect(:get => "/api/teams/1").to route_to("teams#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/api/teams/1/edit").to route_to("teams#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/api/teams").to route_to("teams#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/teams/1").to route_to("teams#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/teams/1").to route_to("teams#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/teams/1").to route_to("teams#destroy", :id => "1")
    end
  end
end
