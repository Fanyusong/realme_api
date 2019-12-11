class AddPriorityToRewardType < ActiveRecord::Migration[5.2]
  def change
    add_column :reward_types, :priority, :integer
  end
end
