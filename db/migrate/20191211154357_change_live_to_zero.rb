class ChangeLiveToZero < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :lives, :integer, default: 1
    change_column :users, :coin, :integer, default: 0
  end
end
