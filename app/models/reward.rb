class Reward < ApplicationRecord
  belongs_to :reward_type
  belongs_to :user
end
