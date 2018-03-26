class PlacePicture < ApplicationRecord
  belongs_to :place

  mount_uploader :picture, PlacePictureUploader

  validates :place_id, presence: true
  validates :picture, presence: true
end
