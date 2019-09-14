class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates  :phone_number, presence: true, uniqueness: true
  validates_presence_of  :name
  has_many :posts

  def sharing_day
    attributes['sharing_day'].strftime("%-m/%-d/%Y") unless attributes['sharing_day'].nil?
  end
end
