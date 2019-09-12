class AddGame4Gam5ToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :game_4, :boolean, default: false
    add_column :users, :game_5, :boolean, default: false
  end
end
