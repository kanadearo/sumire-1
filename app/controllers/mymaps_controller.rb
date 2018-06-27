class MymapsController < ApplicationController
  before_action :set_mymap, only: [:show, :destroy, :edit, :update]
  before_action :sign_in_required

  def show
    if @mymap
      @user = @mymap.user
      @places = @mymap.places.all.order("id DESC")
      place = @mymap.places.first
      if place
        @place_picture = place.place_pictures.first
      end
    else
      redirect_to current_user
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
    open_timing = params[:open][:time]
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

    if @mymap.save
      flash[:success] = "#{@mymap.name}を保存しました。スポットを検索して、リストに登録しましょう！"
      redirect_to places_path
    else
      render :new
    end
  end

  def edit
  end

  def update
      if @mymap.update(update_mymap_params)
        flash[:success] = "#{@mymap.name}を更新しました。"
        redirect_to @mymap
      else
        flash[:warning] = "リスト名を入力してください。"
        redirect_to edit_mymap_path
      end
  end

  def destroy
    @mymap.destroy

    flash[:success] = "#{@mymap.name}を削除しました。"
    redirect_to current_user
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
    opens = place.opens.all
    unless opens.empty?
      open_times = opens.map do |open|
        hash = JSON.parse(open.time)
        hash
      end
      if open_times[0]['close']
        today_open = []
        open_times.each do |opening|
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
    @mymap = Mymap.find_by(id: params[:id])
    if current_user != @mymap.user
      if @mymap.status == 1 || @mymap.status == 2
        redirect_to current_user
      end
    end
  end

  def create_mymap_params
    mymap_params = params.require(:mymap).permit(:name, :comment, :tag_list, :status)
    if mymap_params[:tag_list].include?("、")
      mymap_params[:tag_list] = mymap_params[:tag_list].split("、")
    end
    mymap_params
  end

  def update_mymap_params
    mymap_params = params.require(:mymap).permit(:name, :comment, :status, :tag_list, :picture)
    if mymap_params[:tag_list].include?("、")
      mymap_params[:tag_list] = mymap_params[:tag_list].split("、")
    end
    mymap_params
  end
end
