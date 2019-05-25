class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  attr_accessor :name, :location

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    #
  end

  # GET /teams/new
  def new
    #
  end

  # GET /teams/1/edit
  def edit
    #
  end

  # POST /teams
  # POST /teams.json
  def create
    #
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    #
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    #
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.fetch(:team, {})
    end
end
