class AddPasswordToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password, :string
    add_column :users, :username, :string
  end
end
