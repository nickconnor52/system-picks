require 'open-uri'
require 'uri'
require 'net/http'
require 'openssl'

class Scrape::SpreadFetchController < ApplicationController
  skip_before_action :verify_authenticity_token

  def fetch
    url = URI("https://therundown-therundown-v1.p.mashape.com/sports/2/events")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = ENV['SPREAD_HOST']
    request["x-rapidapi-key"] = ENV['SPREAD_KEY']

    response = http.request(request)
    json_response = JSON.parse(response.body)

    events = json_response["events"]

    # Parse Events
    events.each do |game|

      # Populate Teams
      game["teams_normalized"].each do |team|
        team_abbreviation = team["abbreviation"]
        if team["is_home"]
          @home_team = Team.find_by_sql ["SELECT * FROM teams WHERE (nickname) LIKE ?", "%#{team_abbreviation}%"]
        else
          @away_team = Team.find_by_sql ["SELECT * FROM teams WHERE (nickname) LIKE ?", "%#{team_abbreviation}%"]
        end
      end

      api_spread_hash = game["lines"]["1"] || game["lines"].first
      spread = api_spread_hash["spread"]["point_spread_home"]
      season = DateTime.now.year
      @matchup = Matchup.find_by(home_team: @home_team, away_team: @away_team, season: season)

      begin
        if @matchup.spread_history.blank?
          spread_object = {
            spread: spread,
            date: DateTime.now.strftime('%Q').to_f,
          }
          @spread_history = [spread_object].to_json
        else
          @spread_history = append_spread_to_matchup(spread)
        end

        update_attrs = {
          vegas_spread: spread,
          spread_history: @spread_history,
        }

        @matchup.update(update_attrs)

      rescue
        @error_count += 1
      end
    end

    render :json => { success: true, error_count: @error_count || 0 }
  end

  private

  def append_spread_to_matchup(spread)
    parsed_spread_history = JSON.parse(@matchup.spread_history)
    spread_object = {
      spread: spread,
      date: DateTime.now.strftime('%Q').to_f,
    }
    parsed_spread_history << spread_object
    return parsed_spread_history.to_json
  end


end



