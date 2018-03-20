class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    user_path(id: current_user.id)
  end

  def counts(user)
    @count_mymaps = user.mymaps.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
  end

  def mymap_counts(mymap)
    @count_favoriters = mymap.favoriters.count
  end

  private

  def sign_in_required
    redirect_to root_path unless user_signed_in?
  end
end
