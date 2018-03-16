class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :destroy, :edit, :update]

  def index
    if current_user.mymaps.empty?
      redirect_to new_mymap_path
    end
  end

  def show
  end

  def list
    keyword = params[:search]
    @places = client.spots_by_query( keyword )
    @place = Place.new
  end

  def new
  end

  def create
    place_param, place_photo = place_params
    @place = Place.new(place_param)

    respond_to do |format|
      if @place.save
        if place_photo
          @place.place_pictures.create(picture: place_photo)
        end
        format.html { redirect_to @place, notice: "#{@place.name}の位置情報を保存しました"}
      else
        format.html { redirect_to places_path, notice: "#{@place.name}の位置情報を保存できませんでした"}
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
    place_param = params.require(:place).permit(:mymap_id, :placeId, :memo, :types_name, :types_number)

    place = client.spot(place_param[:placeId])
    place_param[:name] = place.name

    if place.vicinity
      place_param[:address] = place.vicinity
    else
      place_param[:address] = place.formatted_address
    end

    place_param[:phone_number] = place.formatted_phone_number if place.formatted_phone_number
    place_param[:google_url] = place.url if place.url

    if place.opening_hours
      if place.opening_hours['open_now']
        place_param[:open_timing] = "true"
      else
        place_param[:open_timing] = "false"
      end
    else
      place_param[:open_timing] = nil
    end

    types_name = place.types[0]
    place_param[:types_name] = types_name
    types_number = PlaceTypeSets.new.execute(types_name)
    place_param[:types_number] = types_number

    place_photo = place.photos[0]
    if place_photo
      return place_param, place_photo.fetch_url(400)
    else
      return place_param
    end
  end

  def client
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
  end
end
