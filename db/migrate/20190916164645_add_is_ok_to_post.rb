class AddIsOkToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :is_ok, :boolean, default: false
  end
end
