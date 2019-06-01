class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :game_4
    remove_column :users, :game_5
    remove_column :users, :game_6
    add_column :users, :identify, :boolean
    add_column :users, :lives, :integer, default: 3
    add_column :users, :sharing_day, :date
  end
end
