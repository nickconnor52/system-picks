class MatchupsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_matchup, only: [:show, :edit, :update, :destroy]
  attr_accessor :score

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
    @matchup.update(matchup_params)
    @matchup.reload
    render :json => @matchup
  end

  # DELETE /matchups/1
  # DELETE /matchups/1.json
  def destroy
    #
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matchup
      @matchup = Matchup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matchup_params
      params.require(:matchup).permit(:home_team_score, :away_team_score)
    end
end
