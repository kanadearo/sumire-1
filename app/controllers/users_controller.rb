class UsersController < ApplicationController
  before_action :sign_in_required, only: [:show, :edit, :friends, :friend_result, :profile, :followings, :followers]

  def friends
  end

  def friends_result
  end

  def show
    @user = User.find(params[:id])
    @mymaps = @user.feed_mymaps
    @favorites = @user.favoritings(params[:page])
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

end
