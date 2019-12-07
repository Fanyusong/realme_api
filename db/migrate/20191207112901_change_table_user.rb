class ChangeTableUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :game_3
    remove_column :users, :game_4
    remove_column :users, :game_5
  end
end
