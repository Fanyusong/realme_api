class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates  :phone_number, presence: true, uniqueness: true, length: {minimum: 6}
  has_many :rewards

  def sharing_day
    attributes['sharing_day'].strftime("%-m/%-d/%Y") unless attributes['sharing_day'].nil?
  end
end
