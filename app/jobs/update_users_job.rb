class UpdateUsersJob < ApplicationJob
  def perform
    User.find_each do |u|
      u.update(coin: u.lives + 1)
    end
  end
end