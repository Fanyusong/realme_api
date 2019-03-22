class ChangeGame6InUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :game_6, :string, default: ''
  end
end
