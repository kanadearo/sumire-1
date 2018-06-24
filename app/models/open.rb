class Open < ApplicationRecord
  belongs_to :place

  validates :place_id, presence: true
  validates :time, presence: true
end
