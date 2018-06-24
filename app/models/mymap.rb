class Mymap < ApplicationRecord
  acts_as_taggable
  belongs_to :user
  has_many :places, dependent: :delete_all
  has_many :mymap_users, class_name: 'UserMymap', foreign_key: 'mymap_id', dependent: :delete_all
  has_many :favoriters, through: :mymap_users, source: :user

  mount_uploader :picture, MymapPictureUploader

  validates :user_id, presence: true
  validates :name, presence: true
end
