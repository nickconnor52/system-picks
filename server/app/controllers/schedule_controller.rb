class ScheduleController < ApplicationController
    skip_before_action :verify_authenticity_token

    def add_weekly_matchups
      season = schedule_params[:season].nil? ? '2019' : schedule_params[:season]
      Schedule.where(season: season, week: schedule_params[:week]).find_each do |game|
        begin
          matchup = hydrate_matchup(game, season)
          matchup.save!
        rescue
          render :json => { success: false, message: 'I should probably send a helpful error here' }, status: 500
        end
      end

      render :json => { success: true, matchups: Matchup.all }, status: 200
    end

    private
      def hydrate_matchup(game, season)
        home_team = Team.find_by(name: game[:home_team_name])
        away_team = Team.find_by(name: game[:away_team_name])
        matchup_params = {
          away_team_id: away_team.to_param,
          home_team_id: home_team.to_param,
          date: game[:date],
          season: season,
          time: game[:time],
          week: game[:week]
        }
        Matchup.where(matchup_params).first_or_initialize
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def schedule_params
        params.permit([:week, :season])
      end
  end
