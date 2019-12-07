class AddReferenceToReward < ActiveRecord::Migration[5.2]
  def change
    remove_column :rewards, :reward_type
    add_reference :rewards, :reward_type
  end
end
