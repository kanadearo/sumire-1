class PlacePicture < ApplicationRecord
  belongs_to :place

  validates :place_id, presence: true
  validates :picture, presence: true
end
