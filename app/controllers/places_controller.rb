class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :destroy, :edit, :update, :plus_place, :plus_place_create]
  before_action :sign_in_required

  DAY_OF_THE_WEEK={
    0 => "日曜日",
    1 => "月曜日",
    2 => "火曜日",
    3 => "水曜日",
    4 => "木曜日",
    5 => "金曜日",
    6 => "土曜日"
  }

  def index
    if current_user.mymaps.first == nil
      flash[:warning] = "先にマイリストの作成をお願いします。"
      redirect_to new_mymap_path
    end
  end

  def show
    if @place
      @place_pictures = @place.place_pictures.all
      @place_type = @place.types_number
      if @place.open_timing
        openings = @place.open_timing
        @open_timing = openings.map do |opening|
          if opening['close']
            open_day = DAY_OF_THE_WEEK[opening['open']['day']]
            open_time = opening['open']['time']
            close_day = DAY_OF_THE_WEEK[opening['close']['day']]
            close_time = opening['close']['time']
            {
              :open_day => open_day,
              :open_time => open_time,
              :close_day => close_day,
              :close_time => close_time
            }
          else
            {
              :open_forever => "24時間営業中!"
            }
          end
        end
        if openings[0]['close']
          @today_open = open_judge(openings)
        end
      end
    else
      redirect_to current_user
    end
  end

  def plus_place
    @plus_place = Place.new
  end

  def plus_place_create
    begin
      ActiveRecord::Base.transaction do
        place = @place.dup
        place.mymap_id = params['place']['mymap_id']
        place.save!
        if @place.place_pictures.any?
          place_pictures = @place.place_pictures.all
          place_pictures.each do |p|
            new_place_picture = place.place_pictures.new
            new_place_picture.picture = p.picture
            new_place_picture.save!
          end
        end
      end
      mymap = Mymap.find_by(id: params['place']['mymap_id'])
      flash[:success] = "「#{@place.name}」を「#{mymap.name}」に追加しました。"
      redirect_to mymap
    rescue
      flash[:warning] = "追加するマイマップを選択してください。"
      redirect_to plus_place_place_path
    end
  end

  def list
    @keyword = params[:search]
    @places = client.spots_by_query( @keyword, :language => 'ja' )
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.lat
      marker.lng place.lng
      marker.infowindow place.name
    end
    @place = Place.new
  end

  def place_map
    a = params[:array_param]
    c = a.map do |b|
    {
      :infowindow => b['infowindow'],
      :picture => {
        url: "#{ view_context.image_path("sumire.ico")}",
        width: 35,
        height: 35
      },
      :lat => b['lat'],
      :lng => b['lng']
    }
    end
    @hash = c
  end

  def new
  end

  def create
    place_param, place_photo = create_place_params
    if place_param != nil
      @place = Place.new(place_param)

        if @place.save
          if place_photo
            place_picture = @place.place_pictures.new
            place_picture.remote_picture_url = place_photo.gsub('http://','https://')
            place_picture.save!
          end
          flash[:success] = "#{@place.name}の位置情報を保存しました。"
          redirect_to @place.mymap
        else
          flash[:warning] = "#{@place.name}の位置情報を保存できませんでした。"
          redirect_to places_path
        end
    else
      flash[:warning] = "「スポット」と「マイマップ」を選択してください。"
      redirect_to places_path
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
        if place_params['place_pictures']
          place_picture = @place.place_pictures.first
          place_picture.picture = place_params['place_pictures'][:picture]
          place_picture.save!
        end
      end
      flash[:success] = "#{@place.name}の位置情報を更新しました。"
      redirect_to @place.mymap
    rescue
      flash[:warning] = "記入漏れを確認してください。"
      redirect_to edit_place_path
    end
  end

  def destroy
    @place.destroy

    flash[:success] = "#{@place.name}の位置情報を削除しました。"
    redirect_to places_path
  end

  private

  def set_place
    @place = Place.find_by(id: params[:id])
  end

  def create_place_params
    place_param = params.require(:place).permit(:mymap_id, :placeId, :memo, :types_name, :types_number)

    if place_param[:placeId] && (place_param[:mymap_id] != "")
      place = client.spot(place_param[:placeId], :language => "ja")
      place_param[:name] = place.name
      place_param[:latitude] = place.lat
      place_param[:longitude] = place.lng

      vicinity = place.vicinity
      if vicinity
        place_param[:address] = vicinity
      else
        place_param[:address] = place.formatted_address
      end

      formatted_phone_number = place.formatted_phone_number
      place_param[:phone_number] = formatted_phone_number if formatted_phone_number
      url = place.url
      place_param[:google_url] = url if url

      open_timing = place.opening_hours
      if open_timing
        place_param[:open_timing] = open_timing['periods']
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
    else
      nil
    end
  end

  def update_place_params
    params.require(:place).permit(:name, :mymap_id, :memo, place_pictures: %i[picture])
  end

  def open_judge(openings)
    today_open = []
    openings.each do |opening|
      if opening['open']['day'] == Time.now.wday
        today_open.push opening
      end
    end
    if today_open.any?
      open_params = []
      today_open.each do |today|
        time = Time.now
        open = today["open"]["time"]
        close = today["close"]["time"]
        if open >= close
          open = open.scan(/.{1,2}/)
          open_time = Time.local(time.year, time.month, time.day, open[0].to_i, open[1].to_i)
          close = close.scan(/.{1,2}/)

          next_day = time.tomorrow
          if next_day.month == time.month
            close_time = Time.local(time.year, time.month, time.day+1, close[0].to_i, close[1].to_i)
          elsif next_day.month != time.month
            if next_day.year != time.year
              close_time = Time.local(time.year+1, 1, 1, close[0].to_i, close[1].to_i)
            else
              close_time = Time.local(time.year, time.month+1, 1, close[0].to_i, close[1].to_i)
            end
          end

          if open_time <= time && time <= close_time
            open_params.push true
          else
            open_params.push false
          end
        else
          open = open.scan(/.{1,2}/)
          open_time = Time.local(time.year, time.month, time.day,open[0].to_i,open[1].to_i)
          close = close.scan(/.{1,2}/)
          close_time = Time.local(time.year, time.month, time.day,close[0].to_i,close[1].to_i)
          if open_time <= time && time <= close_time
            open_params.push true
          else
            open_params.push false
          end
        end
      end

      if open_params.include?(true)
        return "（只今営業中!）"
      else
        return "（今は営業時間外です）"
      end
    else
      return "（今日は定休日です）"
    end
  end

  def client
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
  end
end
