class UpdateUsersJob < ApplicationJob
  def perform
    User.find_each do |u|
      u.update(lives: u.lives + 1)
    end
  end
end