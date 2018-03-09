class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :destroy]

  def index
    @places = current_user.places.all
  end

  def show
  end

  def list
    keyword = params[:search]
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    places = @client.spots_by_query( keyword )
    @places = places.map do |place|
      @client.spot(place.place_id)
    end
  end

  def new
  end

  def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: "#{@place.name}の位置情報を保存しました"}
      else
        format.html { render :new, notice: "#{@place.name}の位置情報を保存できませんでした"}
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_path, notice: "#{@place.name}の位置情報を削除しました"}
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:user_id, :mymap_id, :name, :placeId, :type, :adress, :phone_number, :google_url, :open_timing, :memo)
  end
end
