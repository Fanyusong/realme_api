class AddIsPassGame4ToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_pass_game4, :boolean, default: false
  end
end
