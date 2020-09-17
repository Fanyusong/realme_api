class AddIsCheatToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_cheat, :boolean, default: false
  end
end
