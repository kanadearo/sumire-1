class UsersController < ApplicationController
  before_action :sign_in_required
  before_action :set_user

  def friends
    @facebook_friends = @user.facebook.get_connection(@user.uid, "friends")
  end

  def show
    @mymaps = mymap_type_sets(@user)
    @favorite_mymaps = favorite_mymap_type_sets(@user)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(update_user_params)
        format.html { redirect_to @user, notice: "#{@user.name}のプロフィールを更新しました"}
      else
        format.html { redirect_to edit_mymap_path, notice: "#{@user.name}のプロフィールを更新できませんでした"}
      end
    end
  end

  def profile
    counts(@user)
  end

  def followings
    @followings = @user.followings.page(params[:page])
  end

  def followers
    @followers = @user.followers.page(params[:page])
  end

  private

  def update_user_params
    params.require(:user).permit(:name, :facebook_url, :twitter_url, :own_url, :picture)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def mymap_type_sets(user)
    if user == current_user
      return user.mymaps.all
    elsif user != current_user
      if current_user.following?(user)
        return user.mymaps.where(status: [0,1])
      else
        return user.mymaps.where(status: 0)
      end
    end
  end

  def favorite_mymap_type_sets(user)
    favorites = user.favoritings.all
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
