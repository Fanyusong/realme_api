class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :avatar
      t.text   :content
      t.timestamps
    end
  end
end
