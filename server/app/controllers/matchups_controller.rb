class MatchupsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_matchup, only: [:show, :edit, :update, :destroy, :get_system_spread, :refresh_system_spread]

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
    unless @matchup.spread_history.blank?
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
      params.require(:matchup).permit(:home_team_score, :away_team_score, :note, :vegas_spread)
    end
end
