class PlacesController < ApplicationController
  def index
    @places = Place.all
  end

  def show
  end

  def list
    keyword = params[:search]
    @client = GooglePlaces::Client.new()
  end
end
