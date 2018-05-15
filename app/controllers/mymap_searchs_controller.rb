class MymapSearchsController < ApplicationController
  def index
    @mymaps = search(params[:search])
    following_users = current_user.followings.all
    following_user_mymaps = []
    if following_users.any?
      following_users.each do |u|
        user_mymap = u.mymaps.where("(status = ?) OR (status = ?)", 0, 1)
        user_mymap.each do |m|
          following_user_mymaps.push m
        end
      end
    end
    @following_user_mymaps = following_user_mymaps
  end

  private

  def search(search)
    if search
      search_result = Mymap.where("name LIKE :text OR comment LIKE :text", text: "%#{search}%").includes(:user)
      mymaps = []
      search_result.each do |mymap|
        unless mymap.user_id == current_user.id
          unless mymap.status == 2
            if mymap.status == 1
              mymap_user = User.find(mymap.user_id)
              if current_user.following?(mymap_user)
               mymaps.push mymap
              end
            elsif mymap.status == 0
              mymaps.push mymap
            end
          end
        else
          mymaps.push mymap
        end
      end
      return mymaps
    else
      nil
    end
  end
end
