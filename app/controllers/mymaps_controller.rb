class MymapsController < ApplicationController
  before_action :set_mymap, only: [:show, :destroy, :edit, :update]
  before_action :sign_in_required

  def show
    @places = @mymap.places.all
    place = @mymap.places.first
    if place
      @place_picture = place.place_pictures.first
    end
  end

  def search
    @user = User.find(params[:user_id])
    if @user == current_user
      @mymaps = @user.feed_mymaps
    else
      @mymaps = feed_secure_mymaps(@user)
    end
  end

  def result
    types_number = params[:types_number]
    open_timing = params[:place][:open_timing]
    places = []
    unless params[:mymap_id][:id].empty?
      mymap_id = params[:mymap_id][:id].to_i
      mymap = Mymap.find(mymap_id)
      place_sets = place_data_set(mymap, types_number, open_timing)
      place_sets.each{|f| places.push f}
      @places = places
    else
      user = User.find(params[:user_id].to_i)
      if user == current_user
        mymaps = user.feed_mymaps
      else
        mymaps = feed_secure_mymaps(user)
      end
      mymaps.each do |mymap|
        place_sets = place_data_set(mymap, types_number, open_timing)
        place_sets.each{|f| places.push f}
      end
      @places = places
    end
  end

  def new
    @mymap = current_user.mymaps.new
  end

  def create
    @mymap = current_user.mymaps.new(create_mymap_params)

    respond_to do |format|
      if @mymap.save
        format.html { redirect_to places_path, notice: "#{@mymap.name}を保存しました"}
      else
        format.html { render :new, notice: "マイマップを保存できませんでした"}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @mymap.update(update_mymap_params)
        format.html { redirect_to @mymap, notice: "#{@mymap.name}の情報を更新しました"}
      else
        format.html { redirect_to edit_mymap_path, notice: "#{@mymap.name}の情報を更新できませんでした"}
      end
    end
  end

  def destroy
    @mymap.destroy

    respond_to do |format|
      format.html { redirect_to current_user, notice: "#{@mymap.name}を削除しました"}
    end
  end

  private

  def place_data_set(mymap, types_number, open_timing)
    if types_number
      if open_timing == "true"
        place_sets = mymap.places.where(types_number: types_number)
        place_set = []
        place_sets.each do |place|
          open_place = open_judge(place)
          if open_place
            place_set.push open_place
          end
        end
        return place_set
      else
        place_sets = mymap.places.where(types_number: types_number)
        return place_sets
      end
    else
      if open_timing == "true"
        place_sets = mymap.places.all
        place_set = []
        place_sets.each do |place|
          open_place = open_judge(place)
          if open_place
            place_set.push open_place
          end
        end
        return place_set
      else
        place_sets = mymap.places.all
        return place_sets
      end
    end
  end

  def feed_secure_mymaps(user)
    user_all_mymaps = user.feed_mymaps
    user_mymaps = []
    if user_all_mymaps
      user_all_mymaps.each do |mymap|
        if mymap.status == 1
          mymap_user = User.find(mymap.user_id)
          if current_user.following?(mymap_user)
            user_mymaps.push mymap
          end
        elsif mymap.status == 0
          user_mymaps.push mymap
        end
      end
    end

    return user_mymaps
  end

  def open_judge(place)
    if place.open_timing
      if place.open_timing[0]['close']
        today_open = []
        place.open_timing.each do |opening|
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
              open_time = Time.local(time.year, time.month, time.day,open[0].to_i,open[1].to_i)
              close = close.scan(/.{1,2}/)
              close_time = Time.local(time.year, time.month, time.day+1 ,close[0].to_i,close[1].to_i)
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
            return place
          end
        end
      else
        return place
      end
    end
  end

  def set_mymap
    @mymap = Mymap.find(params[:id])
  end

  def create_mymap_params
    params.require(:mymap).permit(:name, :comment, :status)
  end

  def update_mymap_params
    params.require(:mymap).permit(:name, :comment, :status, :picture)
  end
end
