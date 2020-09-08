class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates  :phone_number, presence: true, uniqueness: true, length: {minimum: 6}

  def sharing_day
    attributes['sharing_day'].strftime("%-m/%-d/%Y") unless attributes['sharing_day'].nil?
  end

  def serialize_user_data
    {
        name: self&.name,
        email: self&.email,
        phone_number: self&.phone_number,
        game_1: {
            lives: self&.game_1_lives,
            best_time: self&.game_1
        },
        game_2: {
          lives: self&.game_2_lives,
          best_time: self&.game_2
        },
        game_3: {
            lives: self&.game_3_lives,
            best_time: self&.game_3
        },
        game_4: {
            lives: self&.game_4_lives,
            best_time: self&.game_4
        },
        is_qualified: self.is_qualified,
        current_total_time: self.current_total_time
    }
  end
end
