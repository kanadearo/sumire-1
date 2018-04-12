class UserSearchsController < ApplicationController
  def index
    @users = search(params[:search])
    facebook_friends = current_user.facebook.get_connection(current_user.uid, "friends")
    friends = []
    if facebook_friends.any?
      facebook_friends.each do |facebook_friend|
        friend = User.where(uid: facebook_friend['id'])
        if friend.any?
          friend.each do |f|
            friends.push f
          end
        end
      end
    end
    @facebook_friends = friends
    @following_users = current_user.followings.all
  end

  private

  def search(search)
    if search
      User.where("name LIKE ?", "%#{search}%")
    else
      nil
    end
  end
end
