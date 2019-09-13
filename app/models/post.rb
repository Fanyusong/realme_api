class Post < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :content, presence: true
  has_one_attached :avatar
end
