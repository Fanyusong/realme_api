class User < ApplicationRecord
  validates :email, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :phone_number, uniqueness: true
  validates :existence_of_email_or_phone_number
  validate :format_vn_phone_number
  validates_format_of :name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/, allow_nil: true

  DAUSO_VIETNAM = %w(03 05 07 08 09)

  def update_info_game_score score_params
    count = 0
    1..5.times do |i|
      count += 1 if score_params["game_#{i+1}".to_sym].present?
    end
    return false if count != 1
    self.update(game_1: score_params[:game_1]) if score_params[:game_1].present?
    if score_params[:game_2].present? && self.game_1
      self.update(game_2: score_params[:game_2])
      return true
    else
      return false
    end
    if score_params[:game_3].present? && self.game_1 && self.game_2
      self.update(game_3: score_params[:game_3])
      return true
    else
      return false
    end
    if score_params[:game_4].present? && self.game_1 && self.game_2 && self.game_3
      self.update(game_4: score_params[:game_4])
      return true
    else
      return false
    end
    if score_params[:game_5].present? && self.game_1 && self.game_2 && self.game_3 && self.game_4
      self.update(game_5: score_params[:game_5])
      return true
    else
      return false
    end
    if score_params[:game_6].present? && self.game_1 && self.game_2 && self.game_3 && self.game_4 && self.game_5
      self.update(game_6: score_params[:game_6])
      return true
    else
      return false
    end
  end

  private

  def format_vn_phone_number
    if DAUSO_VIETNAM.include? self.phone_number[0,2] || self.phone_number.length != 10
      errors.add :phone_number, 'Phone number is not correct'
    end
  end
end
