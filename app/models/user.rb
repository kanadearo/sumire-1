class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  mount_uploader :picture, PictureUploader

  enum role: { user: 0, admin: 1 }

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user
      user.user_access_token = auth.credentials.token
      user.save!
      return user
    else
      if auth.info.email.empty?
        user = User.new(
                        password: Devise.friendly_token[0,20],
                        name: auth.info.name,
                        image: auth.info.image + "?type=large",
                        uid: auth.uid,
                        provider: auth.provider,
                        user_access_token: auth.credentials.token
                     )
      else
        user = User.new(
                        email: auth.info.email,
                        password: Devise.friendly_token[0,20],
                        name: auth.info.name,
                        image: auth.info.image + "?type=large",
                        uid: auth.uid,
                        provider: auth.provider,
                        user_access_token: auth.credentials.token
                     )
      end
      user.remote_picture_url = process_uri(auth.info.image + "?type=large")
      return user
    end
  end

  validates :name, presence: true
  validates :profile_text, length: { maximum: 200 }

  has_many :mymaps, dependent: :delete_all
  has_many :user_mymaps, dependent: :delete_all
  has_many :favoritings, through: :user_mymaps, source: :mymap

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user

  def facebook
    @facebook ||= Koala::Facebook::API.new(self.user_access_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

  def facebook_access_token!
  end

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

  def self.process_uri(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end

end
