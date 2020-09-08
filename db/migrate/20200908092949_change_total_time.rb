class ChangeTotalTime < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :total_time, :float, default: 0
  end
end
