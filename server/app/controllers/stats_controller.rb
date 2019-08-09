class StatsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_stat, only: [:show, :edit, :update, :destroy]

    # GET /stats
    # GET /stats.json
    def index
      @stats = Stat.all
      render :json => @stats
    end

    # GET /stats/1
    # GET /stats/1.json
    def show
      render :json => @stat
    end

    # GET /stats/new
    def new
      #
    end

    # GET /stats/1/edit
    def edit
      #
    end

    # POST /stats
    # POST /stats.json
    def create
      #
    end

    # PATCH/PUT /stats/1
    # PATCH/PUT /stats/1.json
    def update
      #
    end

    # DELETE /stats/1
    # DELETE /stats/1.json
    def destroy
      #
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_stat
        @stat = Stat.where("team_id = ? AND week = ? AND season = ?", params[:team_id], params[:week], params[:season])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def stat_params
        params.require(:stat).permit(:team_id, :week, :season)
      end
  end
