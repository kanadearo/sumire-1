class UsersController < ApplicationController
  before_action :sign_in_required, only: [:show, :edit, :friends, :friend_result, :profile, :followings, :followers]

  def friends
  end

  def friends_result
  end

  def show
    @user = User.find(params[:id])
    @mymaps = mymap_type_sets(@user)
    @favorite_mymaps = favorite_mymap_type_sets(@user)
  end

  def edit; end

  def profile
    @user = User.find(params[:id])
    counts(@user)
  end

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
  end

  private

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
