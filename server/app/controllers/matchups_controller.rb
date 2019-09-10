class MatchupsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_matchup, only: [:show, :edit, :update, :destroy, :get_system_spread, :refresh_system_spread, :score]

  # GET /matchups
  # GET /matchups.json
  def index
    # Vudo - Need to remove soft-deleted matchups
    @matchups = Matchup.includes(:home_team, :away_team).all
    render :json => @matchups, :include => [:home_team, :away_team]
  end

  # GET /matchups/1
  # GET /matchups/1.json
  def show
    #
  end

  # GET /matchups/new
  def new
    #
  end

  # GET /matchups/1/edit
  def edit
    #
  end

  # POST /matchups
  # POST /matchups.json
  def create
    #
  end

  # PATCH/PUT /matchups/1
  # PATCH/PUT /matchups/1.json
  def update
    # Vudo: Recalculate win or loss value based on updated score (if there is one) -- make own endpoint for score?
    update_params = matchup_params
    if @matchup.spread_history.blank?
      spread_object = {
        spread: matchup_params[:vegas_spread],
        date: DateTime.now.strftime('%Q').to_f,
      }
      spread_history = [spread_object].to_json
      update_params[:spread_history] = spread_history
    else
      spread_history = append_spread_to_matchup
      update_params[:spread_history] = spread_history
    end
    @matchup.update(update_params)
    @matchup.reload

    if !(["home_team_score", "away_team_score", "vegas_spread", "system_spread"] & matchup_params.keys).empty?
      @matchup.correct_pick = @matchup.correct_pick?.to_s
      @matchup.save!
    end

    render :json => @matchup
  end

  # DELETE /matchups/1
  # DELETE /matchups/1.json
  def destroy
    #
  end

  # GET /matchups/1/get_system_pick
  def get_system_spread
    begin
      render :json => { system_pick: @matchup.calculate_system_pick }
    rescue RuntimeError => e
      render :json => { error: e.message }, status: 500
    end
  end

  def refresh_system_spread
    begin
      @matchup.system_spread = @matchup.calculate_system_pick
      @matchup.save!
      render :json => @matchup
    rescue RuntimeError => e
      render :json => { error: e.message }, status: 500
    end
  end

  def score
    auth = {:username => ENV['SPORTS_FEEDS_KEY'], :password => ENV['SPORTS_FEEDS_PASS']}
    game_date = DateTime.parse(@matchup.date).strftime("%Y%m%d")
    uri = "https://api.mysportsfeeds.com/v1.2/pull/nfl/2019-regular/scoreboard.json?fordate=#{game_date}"
    response = HTTParty.get(uri, :basic_auth => auth)

    begin
      scores = JSON.parse(response.body)["scoreboard"]["gameScore"]
      api_matchups = scores.select do |game|
        (game['game']['awayTeam']['City'] == @matchup.away_team['location']) && (game['game']['homeTeam']['City'] == @matchup.home_team['location'])
      end
      result = api_matchups.first

      @matchup.home_team_score = result['homeScore']
      @matchup.away_team_score = result['awayScore']

      @matchup.correct_pick = @matchup.correct_pick?.to_s

      @matchup.save!

      render :json => @matchup
    rescue
      render :json => { error: 'Game score has not been posted yet' }, status: 500
    end
  end

  private
    def append_spread_to_matchup
      parsed_spread_history = JSON.parse(@matchup.spread_history)
      spread_object = {
        spread: matchup_params[:vegas_spread],
        date: DateTime.now.strftime('%Q').to_f,
      }
      parsed_spread_history << spread_object
      return parsed_spread_history.to_json
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_matchup
      @matchup = Matchup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matchup_params
      params.require(:matchup).permit(:home_team_score, :away_team_score, :note, :vegas_spread, :custom_weight)
    end
end
