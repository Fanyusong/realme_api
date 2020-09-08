class AddLivesToUsers < ActiveRecord::Migration[5.2]
  def change
    [:game_1_lives, :game_2_lives, :game_3_lives, :game_4_lives].each do |val|
      add_column :users, val, :integer, default: 2
    end
  end
end
