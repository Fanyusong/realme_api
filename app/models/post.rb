class Post < ApplicationRecord
  validates :name, presence: true
  validates :title, presence: true
  validates :content, presence: true
  has_one_attached :avatar
  belongs_to :post
end
