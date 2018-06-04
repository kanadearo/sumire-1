class UsersController < ApplicationController
  before_action :sign_in_required
  before_action :set_user

  def show
    @mymaps = mymap_type_sets(@user)
    if @mymaps
      all_types = []
      @mymaps.each do |mymap|
        places = mymap.places.all
        places.each{|place| all_types.push place.types_number}
      end
      @all_types = all_types.uniq
    end
  end

  def edit
  end

  def update
      if @user.update(update_user_params)
        flash[:success] = "#{@user.name}のプロフィールを更新しました。"
        redirect_to @user
      else
        flash[:warning] = "名前を入力してください。"
        redirect_to edit_user_path
      end
  end

  def profile
    counts(@user)
    @text = @user.profile_text
  end

  def all_mymap_spots
    @mymaps = mymap_type_sets(@user)
    if @mymaps
      all_places = []
      all_types = []
      @mymaps.each do |mymap|
        places = mymap.places.all
        places.each do |place|
          all_places.push place
          all_types.push place.types_number
        end
      end
      @places = all_places
      @all_types = all_types.uniq
    end
  end

  def like_mymaps
    @favorite_mymaps = favorite_mymap_type_sets(@user)
  end

  def self_mymaps
    @mymaps = mymap_type_sets(@user)
    if @mymaps
      all_types = []
      @mymaps.each do |mymap|
        places = mymap.places.all
        places.each{|place| all_types.push place.types_number}
      end
      @all_types = all_types.uniq
    end
  end

  def followings
    @followings = @user.followings.page(params[:page])
  end

  def followers
    @followers = @user.followers.page(params[:page])
  end

  private

  def update_user_params
    params.require(:user).permit(:name, :profile_text, :own_url, :picture)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def mymap_type_sets(user)
    if user == current_user
      return user.mymaps.all.order("id DESC")
    elsif user != current_user
      if current_user.following?(user)
        return user.mymaps.where(status: [0,1]).order("id DESC")
      else
        return user.mymaps.where(status: 0).order("id DESC")
      end
    end
  end

  def favorite_mymap_type_sets(user)
    favorites = user.favoritings.all.includes(:user).order("id DESC")
    favorite_mymaps = []
    if favorites
      favorites.each do |favorite|
        if favorite.status == 1
          mymap_user = User.find(favorite.user_id)
          if current_user.following?(mymap_user)
            favorite_mymaps.push favorite
          end
        elsif favorite.status == 0
          favorite_mymaps.push favorite
        end
      end
    end

    return favorite_mymaps
  end

end
