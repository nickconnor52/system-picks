require 'open-uri'

class Scrape::StatGenerationController < ApplicationController
  skip_before_action :verify_authenticity_token

  def scrape
    final_stats = []

    # FOOTBALL OUTSIDERS
    # Drive Stats
    drive_stats_hash = get_football_outsiders_drive_stats
    drive_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (nickname) LIKE ?", "%#{drive_team}%"]
      stat_hash = {
        team: team.to_param,
        season: '2019',
        week: '0',
        off_LOS_drive: stat["OFF. LOS/Dr"],
        def_LOS_drive: stat["DEF. LOS/Dr"],
      }
      final_stats << stat_hash
    end

    # FOOTBALL OUTSIDERS
    # Offensive Stats
    offensive_stats_hash = get_football_outsiders_offensive_stats
    offensive_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (nickname) LIKE ?", "%#{drive_team}%"]
      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:off_pts_rz] = stat["Pts/RZ"]
      end
    end

    # FOOTBALL OUTSIDERS
    # Defensive Stats
    defensive_stats_hash = get_football_outsiders_defensive_stats
    defensive_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (nickname) LIKE ?", "%#{drive_team}%"]
      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:def_pts_rz] = stat["Pts/RZ"]
      end
    end

    # espn_give_take_stats_hash = get_espn_stats
    # espn_offensive_third_down_stats_hash = get_espn_stats
    # espn_defensive_third_down_stats_hash = get_espn_stats
    # espn_offensive_yards_stats_hash = get_espn_stats
    # espn_defensive_yards_stats_hash = get_espn_stats
    # team_rankings_offensive_rza_stats_hash = get_other_stats
    # team_rankings_defensive_rza_stats_hash = get_other_stats

    # stat_attrs = {
    #   :team_id => team.to_param,
    #   :season => '2019',
    #   :week => '0',
    #   :def_3rd_pct => '',
    #   :def_pass_yds_game => '270.6',
    #   :def_pts_game => '',
    #   :def_RZA_game => '',
    #   :def_rush_yds_game => '',
    #   :give_take_diff => '',
    #   :off_3rd_pct => '',
    #   :off_pass_yds_game => '',
    #   :off_pts_game => '',
    #   :off_RZA_game => '',
    #   :off_rush_yds_game => '',
    # }

    render :json => {:success => true} unless false
  end

  private

  def convert_row_to_hash(headers, row)
    cells = row.search('td')
    row_hash = {}
    cells.each_with_index do |cell, index|
      header_name = headers[index].text.squish # Strip \n and \t characters (and white space)
      row_hash[header_name] = cell.text.squish
    end
    row_hash
  end

  def get_football_outsiders_drive_stats
    doc = Nokogiri::HTML(open("https://www.footballoutsiders.com/stats/drivestats/2018"))

    # Grab the second table from the site
    table = doc.css('table')[1]
    rows = table.css('tr')
    headers = rows.shift.search('th')
    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build
  end

  def get_football_outsiders_offensive_stats
    doc = Nokogiri::HTML(open("https://www.footballoutsiders.com/stats/drivestatsoff/2018"))

    # Grab the second table from the site
    table = doc.css('table')[1]
    rows = table.css('tr')
    headers = rows.shift.search('th')
    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build
  end

  def get_football_outsiders_defensive_stats
    doc = Nokogiri::HTML(open("https://www.footballoutsiders.com/stats/drivestatsdef/2018"))

    # Grab the second table from the site
    table = doc.css('table')[1]
    rows = table.css('tr')
    headers = rows.shift.search('th')
    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build
  end
end
