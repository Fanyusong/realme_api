class AddReferenceToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :rewards, :user
  end
end
