class Place < ApplicationRecord
  belongs_to :mymap
  has_many :place_pictures, dependent: :delete_all
  has_many :opens, dependent: :delete_all

  validates :mymap_id, presence: true
  validates :name, presence: true
  validates :types_name, presence: true
  validates :types_number, presence: true
  validates :address, presence: true
  validates :placeId, presence: true
end
