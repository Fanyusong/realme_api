class AddBestGame4ToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :best_game4, :integer
  end
end
