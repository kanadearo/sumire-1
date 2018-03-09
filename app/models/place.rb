class Place < ApplicationRecord
  belongs_to :user
  belongs_to :mymap
  has_many :place_pictures, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true
  validates :type, presence: true
  validates :adress, presence: true
  validates :placeId, presence: true
end
