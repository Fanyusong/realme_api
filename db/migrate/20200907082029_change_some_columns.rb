class ChangeSomeColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :game_1, :text, default: nil
    change_column :users, :game_2, :text, default: nil
    change_column :users, :game_3, :text, default: nil
    change_column :users, :game_4, :text, default: nil
  end
end
