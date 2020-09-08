class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates  :phone_number, presence: true, uniqueness: true, length: {minimum: 6}
  has_many :rewards

  def sharing_day
    attributes['sharing_day'].strftime("%-m/%-d/%Y") unless attributes['sharing_day'].nil?
  end

  def serialize_user_data
    {
        email: self.email,
        phone_number: self.phone_number,
        game_1: self.game_1,
        game_2: self.game_2,
        game_3: self.game_3,
        game_4: self.game_4,
        total_time: self.total_time
    }
  end
end
