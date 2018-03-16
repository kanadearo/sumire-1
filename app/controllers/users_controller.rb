class UsersController < ApplicationController
  before_action :sign_in_required, only: [:show]

  def show
    @mymaps = current_user.mymaps.all
  end

  def edit; end
end
