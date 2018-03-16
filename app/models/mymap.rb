class Mymap < ApplicationRecord
  belongs_to :user
  has_many :places, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true
end
