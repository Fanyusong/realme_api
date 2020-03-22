class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :game_4_time, :integer, default: 0
    add_column :users, :ticket_type_1, :integer, default: 0
    add_column :users, :ticket_type_2, :integer, default: 0
    add_column :users, :ticket_type_3, :integer, default: 0
  end
end
