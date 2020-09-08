class RemoveSomeColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :ticket_type_1
    remove_column :users, :ticket_type_2
    remove_column :users, :ticket_type_3
    remove_column :users, :game_4_time
    add_column :users, :game_1_float, :float, default: 0
    add_column :users, :game_2_float, :float, default: 0
    add_column :users, :game_3_float, :float, default: 0
    add_column :users, :game_4_float, :float, default: 0
    add_column :users, :total, :float, default: 0
  end
end
