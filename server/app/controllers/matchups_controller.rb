class MatchupsController < ApplicationController
  before_action :set_matchup, only: [:show, :edit, :update, :destroy]

  # GET /matchups
  # GET /matchups.json
  def index
    @matchups = Matchup.all
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
    #
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
      params.fetch(:matchup, {})
    end
end
