class RewardType < ApplicationRecord
  has_many :reward_lists
  has_many :rewards
end
