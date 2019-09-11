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
      unless team.to_param.empty?
        stat_hash = {
          team: team.to_param,
          season: stat_params[:season],
          week: stat_params[:week],
          off_LOS_drive: stat["OFF. LOS/Dr"].split().first, # The regular season keeps rank in () for this site
          def_LOS_drive: stat["DEF. LOS/Dr"].split().first,
        }
        final_stats << stat_hash
      end
    end

    # FOOTBALL OUTSIDERS
    # Offensive Stats
    offensive_stats_hash = get_football_outsiders_offensive_stats
    offensive_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (nickname) LIKE ?", "%#{drive_team}%"]
      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:off_pts_rz] = stat["Pts/RZ"].split().first
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
        existing_stat_hash[:def_pts_rz] = stat["Pts/RZ"].split().first
      end
    end

    # ESPN Stats
    # Give Take

    espn_give_take_stats_hash = get_espn_give_take_stats
    espn_give_take_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (name) LIKE ?", "%#{drive_team}%"]
      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:give_take_diff] = stat["DIFF"]
      end
    end

    # ESPN Stats
    # OFF 3rd Down

    espn_offensive_third_down_stats_hash = get_espn_offensive_third_stats
    espn_offensive_third_down_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (name) LIKE ?", "%#{drive_team}%"]
      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:off_3rd_pct] = stat["PCT"]
      end
    end

    # ESPN Stats
    # DEF 3rd Down
    espn_defensive_third_down_stats_hash = get_espn_defensive_third_stats
    espn_defensive_third_down_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (name) LIKE ?", "%#{drive_team}%"]
      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:def_3rd_pct] = stat["PCT"]
      end
    end

    # ESPN Stats
    # OFF Yards Stats
    espn_offensive_yards_stats_hash = get_espn_offensive_yardage_stats
    espn_offensive_yards_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (name) LIKE ?", "%#{drive_team}%"]
      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:off_pass_yds_game] = stat["YDS/G4"]
        existing_stat_hash[:off_rush_yds_game] = stat["YDS/G6"]
        existing_stat_hash[:off_pts_game] = stat["PTS/G8"]
      end
    end

    # ESPN Stats
    # DEF Yards Stats
    espn_defensive_yards_stats_hash = get_espn_defensive_yardage_stats
    espn_defensive_yards_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (name) LIKE ?", "%#{drive_team}%"]
      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:def_pass_yds_game] = stat["YDS/G4"]
        existing_stat_hash[:def_rush_yds_game] = stat["YDS/G6"]
        existing_stat_hash[:def_pts_game] = stat["PTS/G8"]
      end
    end

    # TeamRankings Stats
    # OFF RZA
    team_rankings_offensive_rza_stats_hash = get_off_team_rankings_RZ_stats
    team_rankings_offensive_rza_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (location) LIKE ?", "%#{drive_team}%"]
      if team.empty?
        team = Team.find_by_sql ["SELECT * FROM teams WHERE (nickname) LIKE ?", "%#{drive_team}%"]
      end

      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:off_RZA_game] = stat["2019"]
      end
    end

    # TeamRankings Stats
    # DEF RZA
    team_rankings_defensive_rza_stats_hash = get_def_team_rankings_RZ_stats
    team_rankings_defensive_rza_stats_hash.each do |stat|
      drive_team = stat["Team"]
      team = Team.find_by_sql ["SELECT * FROM teams WHERE (location) LIKE ?", "%#{drive_team}%"]
      if team.empty?
        team = Team.find_by_sql ["SELECT * FROM teams WHERE (nickname) LIKE ?", "%#{drive_team}%"]
      end

      existing_stat_hash = final_stats.detect {|needle| needle[:team] == team.to_param}

      unless existing_stat_hash.nil?
        existing_stat_hash[:def_RZA_game] = stat["2019"]
      end
    end

    persist_stats final_stats

    render :json => final_stats
  end

  private

  def persist_stats(final_stats)
    final_stats.each do |stat|
      stat[:team] = Team.find(stat[:team])
      upserted_stat = Stat.where(team: stat[:team].to_param, week: stat[:week], season: stat[:season]).first_or_initialize
      upserted_stat.update(stat)
    end
  end

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
    doc = Nokogiri::HTML(open("https://www.footballoutsiders.com/stats/drivestats/2019"))

    # Grab the second table from the site
    table = doc.css('table')[1]
    rows = table.css('tr')
    headers = rows.shift.search('td')
    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build
  end

  def get_football_outsiders_offensive_stats
    doc = Nokogiri::HTML(open("https://www.footballoutsiders.com/stats/drivestatsoff/2019"))

    # Grab the second table from the site
    table = doc.css('table')[1]
    rows = table.css('tr')
    headers = rows.shift.search('td')
    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build
  end

  def get_football_outsiders_defensive_stats
    doc = Nokogiri::HTML(open("https://www.footballoutsiders.com/stats/drivestatsdef/2019"))

    # Grab the second table from the site
    table = doc.css('table')[1]
    rows = table.css('tr')
    headers = rows.shift.search('td')
    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build
  end

  def get_espn_give_take_stats
    doc = Nokogiri::HTML(open("https://www.espn.com/nfl/stats/team/_/view/turnovers/season/2019/seasontype/2"))

    # Grab the second table from the site
    table = doc.css('table')[0]
    teams_column = table.search('.v-top').first

    teams_array = teams_column.search('tbody tr')
    rows = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/tbody').search('tr')
    headers = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/thead[2]/tr').search('th')


    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build.each_with_index do |hash, index|
      team = teams_array[index]
      team_name = team.text.split.last
      hash["Team"] = team_name
    end

    hash_build
  end

  def get_espn_offensive_third_stats
    doc = Nokogiri::HTML(open("https://www.espn.com/nfl/stats/team/_/season/2019/seasontype/2/stat/downs"))

    # Grab the second table from the site
    table = doc.css('table')[0]
    teams_column = table.search('.v-top').first

    teams_array = teams_column.search('tbody tr')
    rows = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/tbody').search('tr')
    headers = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/thead[2]/tr').search('th')


    hash_build = []
    rows.each do |row|
      row_hash = convert_percentage_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build.each_with_index do |hash, index|
      team = teams_array[index]
      team_name = team.text.split.last
      hash["Team"] = team_name
    end

    hash_build
  end

  def get_espn_defensive_third_stats
    doc = Nokogiri::HTML(open("https://www.espn.com/nfl/stats/team/_/view/defense/season/2019/seasontype/2/stat/downs"))

    # Grab the second table from the site
    table = doc.css('table')[0]
    teams_column = table.search('.v-top').first

    teams_array = teams_column.search('tbody tr')
    rows = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/tbody').search('tr')
    headers = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/thead[2]/tr').search('th')


    hash_build = []
    rows.each do |row|
      row_hash = convert_percentage_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build.each_with_index do |hash, index|
      team = teams_array[index]
      team_name = team.text.split.last
      hash["Team"] = team_name
    end

    hash_build
  end


  def get_espn_offensive_yardage_stats
    doc = Nokogiri::HTML(open("https://www.espn.com/nfl/stats/team/_/view/offense/season/2019/seasontype/2"))

    # Grab the second table from the site
    table = doc.css('table')[0]
    teams_column = table.search('.v-top').first

    teams_array = teams_column.search('tbody tr')
    rows = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/tbody').search('tr')
    headers = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/thead[2]/tr').search('th')


    hash_build = []
    rows.each do |row|
      row_hash = convert_yardage_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build.each_with_index do |hash, index|
      team = teams_array[index]
      team_name = team.text.split.last
      hash["Team"] = team_name
    end

    hash_build
  end

  def get_espn_defensive_yardage_stats
    doc = Nokogiri::HTML(open("https://www.espn.com/nfl/stats/team/_/view/defense/season/2019/seasontype/2"))

    # Grab the second table from the site
    table = doc.css('table')[0]
    teams_column = table.search('.v-top').first

    teams_array = teams_column.search('tbody tr')
    rows = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/tbody').search('tr')
    headers = table.search('//*[@id="fittPageContainer"]/div/div[1]/div/article/div/section/table/tbody/tr/td[2]/div/div/div[2]/table/tbody/tr/td/div/table/thead[2]/tr').search('th')


    hash_build = []
    rows.each do |row|
      row_hash = convert_yardage_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build.each_with_index do |hash, index|
      team = teams_array[index]
      team_name = team.text.split.last
      hash["Team"] = team_name
    end

    hash_build
  end

  def get_off_team_rankings_RZ_stats
    doc = Nokogiri::HTML(open("https://www.teamrankings.com/nfl/stat/red-zone-scoring-attempts-per-game"))

    # Grab the second table from the site
    table = doc.css('table')[0]
    rows = table.search('tbody').search('tr')
    headers = table.search('thead tr').search('th')


    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build
  end

  def get_def_team_rankings_RZ_stats
    doc = Nokogiri::HTML(open("https://www.teamrankings.com/nfl/stat/opponent-red-zone-scoring-attempts-per-game"))

    # Grab the second table from the site
    table = doc.css('table')[0]
    rows = table.search('tbody').search('tr')
    headers = table.search('thead tr').search('th')


    hash_build = []
    rows.each do |row|
      row_hash = convert_row_to_hash(headers, row)
      hash_build << row_hash
    end

    hash_build
  end

  def convert_percentage_row_to_hash(headers, row)
    cells = row.search('td')
    row_hash = {}
    cells.each_with_index do |cell, index|
      header_name = headers[index].text.squish # Strip \n and \t characters (and white space)
      row_hash[header_name] = cell.text.squish
      if index > 7
        break # There are duplicate PCTs for 3rd downs and 4th downs
      end
    end
    row_hash
  end

  def convert_yardage_row_to_hash(headers, row)
    cells = row.search('td')
    row_hash = {}
    cells.each_with_index do |cell, index|
      header_name = headers[index].text.squish # Strip \n and \t characters (and white space)
      row_hash[header_name << index.to_s] = cell.text.squish # index due to multiple percentages
    end
    row_hash
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stat_params
    params.permit([:week, :season])
  end
end
