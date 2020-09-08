class AddPreviousValueToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :prev_game1, :float, default: 0
    add_column :users, :prev_game2, :float, default: 0
    add_column :users, :prev_game3, :float, default: 0
    add_column :users, :prev_game4, :float, default: 0
  end
end
