class Scrape::ScheduleFetchController < ApplicationController
  def fetch
    auth = {:username => ENV['SPORTS_FEEDS_KEY'], :password => ENV['SPORTS_FEEDS_PASS']}
    response = HTTParty.get("https://api.mysportsfeeds.com/v1.2/pull/nfl/2019-regular/full_game_schedule.json",
                     :basic_auth => auth)
    games = JSON.parse(response.body)["fullgameschedule"]["gameentry"]
    games.each do |game|
      new_game = {
        away_team_abbreviation: game['awayTeam']['Abbreviation'],
        away_team_city: game['awayTeam']['City'],
        away_team_api_id: game['awayTeam']['ID'],
        away_team_name: game['awayTeam']['Name'],
        home_team_abbreviation: game['homeTeam']['Abbreviation'],
        home_team_city: game['homeTeam']['City'],
        home_team_api_id: game['homeTeam']['ID'],
        home_team_name: game['homeTeam']['Name'],
        date: game['date'],
        delayed_or_postponed_reason: game['delayedOrPostponedReason'],
        api_id: game['id'],
        location: game['location'],
        original_date: game['originalDate'],
        original_time: game['originalTime'],
        schedule_status: game['scheduleStatus'],
        season: DateTime.parse(game['date']).year,
        time: game['time'],
        week: game['week'],
      }
      upsert_schedule = Schedule.where(new_game).first_or_initialize
      upsert_schedule.save!
    end
  end
end
