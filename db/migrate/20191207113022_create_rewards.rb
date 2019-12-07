class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.integer :reward_number
      t.integer :reward_type
      t.string :description
      t.timestamps
    end
  end
end
