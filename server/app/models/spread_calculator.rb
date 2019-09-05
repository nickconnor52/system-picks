class SpreadCalculator
  @@points_per_yard = 0.06468441

  def initialize(attributes = {})
    @home_team = attributes[:matchup].home_team
    @away_team = attributes[:matchup].away_team
    @week = attributes[:matchup].week
    @season = attributes[:matchup].season
    @home_stats = Stat.find_by({ team_id: @home_team.id, season: @season, week: @week })
    @away_stats = Stat.find_by({ team_id: @away_team.id, season: @season, week: @week })
    @custom_weight = attributes[:matchup].custom_weight.to_f

    if @home_stats.nil? || @away_stats.nil?
      raise "Stats don't exist for this matchup"
    end
  end

  # Better to define an initializer instead of pass directly to calculate_spread?
  def calculate_spread
    home_team_calculated_properties = get_calculated_properties(@home_stats, @away_stats, @home_team.bye_week)
    away_team_calculated_properties = get_calculated_properties(@away_stats, @home_stats, @away_team.bye_week)

    return apply_point_adjustments(home_team_calculated_properties, away_team_calculated_properties)
  end

  def apply_point_adjustments(home_team, away_team)
    home_weighted_total = 0
    away_weighted_total = 0

    # Points from Starting Position
    if home_team[:LOS_per_drive] > 30
      home_weighted_total += 2
    end

    if away_team[:LOS_per_drive] > 30
      away_weighted_total += 2
    end

    # Turnover Diff Adjust
    give_take_adjustment = 0

    if home_team[:give_take_per_game] > away_team[:give_take_per_game]
      give_take_adjustment = (home_team[:give_take_per_game] - away_team[:give_take_per_game]) * 3
      home_weighted_total += give_take_adjustment
    else
      give_take_adjustment = (away_team[:give_take_per_game] - home_team[:give_take_per_game]) * 3
      away_weighted_total += give_take_adjustment
    end

    # Points from 3rd Down
    home_third_adjust = home_team[:third_down_pct] - away_team[:third_down_pct]
    away_third_adjust = home_third_adjust * -1

    if home_third_adjust >= 7
      home_weighted_total += 1
    elsif home_third_adjust >= 4.5
      home_weighted_total += 0.5
    elsif away_third_adjust >= 7
      away_weighted_total += 0.5
    elsif away_third_adjust >= 4.5
      away_weighted_total += 0.5
    end

    # RZ Difference

    if home_team[:RZA_pts] > away_team[:RZA_pts]
      home_weighted_total += home_team[:RZA_pts] - away_team[:RZA_pts]
    elsif away_team[:RZA_pts] > home_team[:RZA_pts]
      away_weighted_total += away_team[:RZA_pts] - home_team[:RZA_pts]
    end

    # HFA
    home_weighted_total += @home_team.home_field_advantage.to_f

    home_ppg_adjust = 0
    away_ppg_adjust = 0

    # PPG Difference

    if home_team[:adjusted_points_per_game] > away_team[:adjusted_points_per_game]
      home_ppg_adjust = home_team[:adjusted_points_per_game] - away_team[:adjusted_points_per_game]
      home_weighted_total += home_ppg_adjust
    elsif away_team[:adjusted_points_per_game] > home_team[:adjusted_points_per_game]
      away_ppg_adjust = away_team[:adjusted_points_per_game] - home_team[:adjusted_points_per_game]
      away_weighted_total += away_ppg_adjust
    end

    # ADD PPG ADJUST TO SPREAD CALC
    home_final_score = (home_weighted_total + home_team[:adjusted_points_per_game]) - home_ppg_adjust
    away_final_score = (away_weighted_total + away_team[:adjusted_points_per_game]) - away_ppg_adjust

    return (( home_final_score - away_final_score ) * -1) + @custom_weight

  end

  def get_calculated_properties(team, opponent, bye_week)
    properties = {}

    properties[:LOS_per_drive] = find_average(team.off_LOS_drive, opponent.def_LOS_drive)
    properties[:third_down_pct] = find_average(team.off_3rd_pct, opponent.def_3rd_pct)

    properties[:give_take_per_game] = team.give_take_diff.to_f / games_played(bye_week)

    properties[:rza_per_game] = find_average(team.off_RZA_game, opponent.def_RZA_game)
    properties[:pts_per_RZA] = find_average(team.off_pts_rz, opponent.def_pts_rz)
    properties[:RZA_pts] = properties[:pts_per_RZA] * properties[:rza_per_game]

    properties[:pass_yds_per_game] = find_average(team.off_pass_yds_game, opponent.def_pass_yds_game)
    properties[:rush_yds_per_game] = find_average(team.off_rush_yds_game, opponent.def_rush_yds_game)
    properties[:total_yds_per_game] = properties[:pass_yds_per_game] + properties[:rush_yds_per_game]

    properties[:points_from_yards] = properties[:total_yds_per_game] * @@points_per_yard
    properties[:points_per_game] = find_average(team.off_pts_game, opponent.def_pts_game)

    properties[:adjusted_points_per_game] = find_average(properties[:points_per_game], properties[:points_from_yards])

    return properties
  end

  private

  def find_average(team_stat, opponent_stat)
    (team_stat.to_f + opponent_stat.to_f) / 2
  end

  def games_played(bye_week)
    # Handle case where stats come from last season on start of year
    if @week === 1
      return 1
    end

    bye_week < @week ? @week - 2 : @week - 1
  end
end
