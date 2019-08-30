class Scrape::FootballOutsidersController < ApplicationController
    skip_before_action :verify_authenticity_token
    # before_action :set_stat, only: [:show, :edit, :update, :destroy]

    # GET /stats
    # GET /stats.json
    def scrape
      render :json => {:test => 'success'}
    end
  end
