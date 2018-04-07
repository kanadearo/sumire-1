class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :destroy, :edit, :update]
  before_action :sign_in_required

  def index
  end

  def show
    @place_pictures = @place.place_pictures.all
  end

  def list
    keyword = params[:search]
    @places = client.spots_by_query( keyword )
    @place = Place.new
  end

  def new
  end

  def create
    place_param, place_photo = create_place_params
    @place = Place.new(place_param)

    respond_to do |format|
      if @place.save
        if place_photo
          place_picture = @place.place_pictures.new
          place_picture.remote_picture_url = place_photo.gsub('http://','https://')
          place_picture.save!
        end
        format.html { redirect_to @place, notice: "#{@place.name}の位置情報を保存しました"}
      else
        format.html { redirect_to places_path, notice: "#{@place.name}の位置情報を保存できませんでした"}
      end
    end
  end

  def edit
    @place.place_pictures.new
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        place_params = update_place_params
        @place.name = place_params['name'] if place_params['name']
        @place.mymap_id = place_params['mymap_id'] if place_params['mymap_id']
        @place.memo = place_params['memo'] if place_params['memo']
        @place.save!
        if place_params['place_picture']
          place_picture = @place.place_pictures.new
          place_picture.picture = place_params['place_pictures'][:picture]
          place_picture.save!
        end
      end
      flash[:notice] = "#{@place.name}の位置情報を更新しました"
      redirect_to @place
    rescue
      flash[:notice] = "#{@place.name}の位置情報を更新できませんでした"
      redirect_to edit_place_path
    end
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

  def create_place_params
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
      return place_param, place_photo.fetch_url(600)
    else
      return place_param
    end
  end

  def update_place_params
    params.require(:place).permit(:name, :mymap_id, :memo, place_pictures: %i[picture])
  end

  def client
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
  end
end
