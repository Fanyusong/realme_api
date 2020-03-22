class AddMoreColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :game_3, :boolean, default: false
    add_column :users, :game_5, :boolean, default: false
  end
end
