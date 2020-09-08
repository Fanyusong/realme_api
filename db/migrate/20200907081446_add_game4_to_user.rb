class AddGame4ToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :game_4, :text
    change_column :users, :game_1, :text
    change_column :users, :game_2, :text
    change_column :users, :game_3, :text
  end
end
