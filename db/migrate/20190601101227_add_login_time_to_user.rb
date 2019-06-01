class AddLoginTimeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :login_date, :date
  end
end
