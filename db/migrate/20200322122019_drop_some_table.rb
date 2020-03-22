class DropSomeTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :random_numbers
    drop_table :reward_lists
    drop_table :reward_types
    drop_table :rewards
    drop_table :histories
  end
end
