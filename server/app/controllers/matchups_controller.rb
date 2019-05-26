class MatchupsController < ApplicationController
  before_action :set_matchup, only: [:show, :edit, :update, :destroy]
  attr_accessor :score

  # GET /matchups
  # GET /matchups.json
  def index
    # TODO - need to join the home and away team info (https://guides.rubyonrails.org/active_record_querying.html)
    @matchups = Matchup.all

    render :json => @matchups
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
