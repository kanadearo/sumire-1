class UserMymap < ApplicationRecord
  belongs_to :user
  belongs_to :mymap

  validates :user_id, presence: true
  validates :mymap_id, presence: true
end
