class UpdateUsersJob < ApplicationJob
  def perform
    User.find_each do |u|
      u.update(coin: u.coin + 1000)
    end
  end
end