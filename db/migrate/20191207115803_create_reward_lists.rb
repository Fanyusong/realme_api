class CreateRewardLists < ActiveRecord::Migration[5.2]
  def change
    create_table :reward_lists do |t|
      t.integer :random_number, unique: true
      t.timestamps
    end
  end
end
