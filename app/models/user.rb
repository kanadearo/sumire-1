class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
        user.image = auth.info.image
        user.uid = auth.uid
        user.provider = auth.provider
      end
    end
  end

  has_many :mymaps, dependent: :destroy
  has_many :user_mymaps
  has_many :favoritings, through: :user_mymaps, source: :mymap

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def favorite(mymap)
    self.user_mymaps.find_or_create_by(mymap_id: mymap.id)
  end

  def unfavorite(mymap)
    favorite = self.user_mymaps.find_by(mymap_id: mymap.id)
    favorite.destroy if favorite
  end

  def feed_mymaps
    Mymap.where(id: self.favoriting_ids + self.mymaps.ids)
  end

  def favoriting?(mymap)
    self.favoritings.include?(mymap)
  end
end
