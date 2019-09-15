class Post < ApplicationRecord
  validates :name, presence: true
  validates :title, presence: true
  validates :content, presence: true
  mount_uploader :avatar, AvatarUploader
  belongs_to :user
end
