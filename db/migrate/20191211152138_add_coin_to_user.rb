class AddCoinToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :coin, :integer, default: 1000
  end
end
