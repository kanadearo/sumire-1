class Mymap < ApplicationRecord
  belongs_to :user
  has_many :places, dependent: :destroy
  has_many :mymap_users, class_name: 'UserMymap', foreign_key: 'mymap_id'
  has_many :favoriters, through: :mymap_users, source: :user

  validates :user_id, presence: true
  validates :name, presence: true
end
