class AddReferenceToRewardType < ActiveRecord::Migration[5.2]
  def change
    add_reference :reward_lists, :reward_type
  end
end
