class User < ApplicationRecord
  validates :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP, unless: Proc.new { |record| record.email.blank? }
  validates :phone_number, presence: true, uniqueness: true
  validate :format_vn_phone_number
  validates_presence_of  :name
  validates_format_of :name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/, allow_nil: true

  DAUSO_VIETNAM = %w(03 05 07 08 09)

  def update_info_game_score score_params
    count = 0
    1..6.times do |i|
      count += 1 if score_params["game_#{i+1}".to_sym].present?
    end
    return false if count != 1
    if score_params[:game_1].present?
      self.update(game_1: score_params[:game_1])
      return true
    end
    if score_params[:game_2].present?
      self.update(game_2: score_params[:game_2])
      return true
    end
    if score_params[:game_3].present?
      self.update(game_3: score_params[:game_3])
      return true
    end
    if score_params[:game_4].present?
      self.update(game_4: score_params[:game_4])
      return true
    end
    if score_params[:game_5].present?
      self.update(game_5: score_params[:game_5])
      return true
    end
    if score_params[:game_6].present?
      self.update(game_6: score_params[:game_6])
      return true
    end
    return false
  end

  private

  def format_vn_phone_number
    unless self.phone_number.blank?
      if !DAUSO_VIETNAM.include? self.phone_number[0,2]
        errors.add :phone_number, 'is not correct'
      end
      if self.phone_number.length != 10
        errors.add :phone_number, 'is not correct'
      end
    end
  end
end
