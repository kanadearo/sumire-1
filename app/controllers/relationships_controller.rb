class RelationshipsController < ApplicationController
  before_action :sign_in_required

  def create
    user = User.find_by(id: params[:follow_id])
    current_user.follow(user)
    flash[:success] = 'ユーザーをフォローしました。'
    redirect_to facebook_users_user_searchs
  end

  def destroy
    user = User.find_by(id: params[:id])
    current_user.unfollow(user)
    flash[:success] = 'ユーザーのフォローを解除しました。'
    redirect_to facebook_users_user_searchs
  end
end
