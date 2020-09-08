class RemoveUnusedColumnsInUser < ActiveRecord::Migration[5.2]
  def change
    [:game_1_float, :game_2_float, :game_3_float, :game_4_float, :coin, :lives, :username, :total, :game_5].each do |v|
      remove_column :users, v
    end
  end
end
