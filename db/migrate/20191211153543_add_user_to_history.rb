class AddUserToHistory < ActiveRecord::Migration[5.2]
  def change
    add_reference :histories, :user
  end
end
