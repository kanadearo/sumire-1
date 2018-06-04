class RelationshipsController < ApplicationController
  before_action :sign_in_required

  def create
    user = User.find_by(id: params[:follow_id])
    current_user.follow(user)
    flash[:success] = 'ユーザをフォローしました。'
    redirect_to user
  end

  def destroy
    user = User.find_by(id: params[:id])
    current_user.unfollow(user)
    flash[:success] = 'ユーザのフォローを解除しました。'
    redirect_to user
  end
end
