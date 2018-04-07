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
    @mymaps = @user.feed_mymaps
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
      mymaps = user.feed_mymaps
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
        place_sets = mymap.places.where(types_number: types_number).where(open_timing: open_timing)
        return place_sets
      else
        place_sets = mymap.places.where(types_number: types_number)
        return place_sets
      end
    else
      if open_timing == "true"
        place_sets = mymap.places.where(open_timing: open_timing)
        return place_sets
      else
        place_sets = mymap.places.all
        return place_sets
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
