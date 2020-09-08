class ModifyUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_total_time, :integer, default: 0
    add_column :users, :is_qualified, :boolean, default: false
    [:game_1, :game_2, :game_3, :game_4, :total_time, :prev_game1, :prev_game2, :prev_game3, :prev_game4].each do |v|
      remove_column :users, v
    end
    add_column :users, :total_time, :integer, default: 120000
    add_column :users, :game_1, :integer
    add_column :users, :game_2, :integer
    add_column :users, :game_3, :integer
    add_column :users, :game_4, :integer
    add_column :users, :prev_game_1, :integer, default: 30000
    add_column :users, :prev_game_2, :integer, default: 30000
    add_column :users, :prev_game_3, :integer, default: 30000
    add_column :users, :prev_game_4, :integer, default: 30000
  end
end
