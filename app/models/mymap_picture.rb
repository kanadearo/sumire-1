class MymapPicture < ApplicationRecord
  belongs_to :mymap

  mount_uploader :picture, MymapPictureUploader

  validates :mymap_id, presence: true
  validates :picture, presence: true
end
