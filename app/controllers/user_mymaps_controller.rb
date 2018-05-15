class UserMymapsController < ApplicationController
  before_action :sign_in_required

  def create
    mymap = Mymap.find_by(id: params["format"])
    current_user.favorite(mymap)
    flash[:success] = "「#{mymap.name}」をお気に入りに登録しました。"
    redirect_to user_path(mymap.user.id)
  end

  def destroy
    mymap = Mymap.find(params[:mymap_id])
    current_user.unfavorite(mymap)
    flash[:success] = "「#{mymap.name}」のお気に入りを解除しました。"
    redirect_to user_path(current_user.id)
  end
end
