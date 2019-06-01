class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates  :phone_number, presence: true, uniqueness: true
  validates_presence_of  :name

  def sharing_day
    attributes['sharing_day'].strftime("%-m/%-d/%Y")
  end
end
