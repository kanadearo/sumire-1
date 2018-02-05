class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    user_path(id: current_user.id)
  end

  private

  def sign_in_required
    redirect_to root_path unless user_signed_in?
  end
end
