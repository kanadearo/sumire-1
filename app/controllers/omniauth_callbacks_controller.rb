class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    p @user
    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', :kind => "Facebook")
      remember_me(@user)
#      sign_in_and_redirect @user, :event => :authentication
      sign_in @user
      redirect_to @user
    else
      @user.save!
      if @user.persisted?
        remember_me(@user)
        sign_in @user
        redirect_to env_selections_path
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to root_path
      end
    end
  end

  def failure
    redirect_to root_path
  end
end
