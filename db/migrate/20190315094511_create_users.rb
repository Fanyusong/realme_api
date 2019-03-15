class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :phone_number
      t.string :name
      t.text :address
      t.boolean :game_1, default: false
      t.boolean :game_2, default: false
      t.boolean :game_3, default: false
      t.boolean :game_4, default: false
      t.boolean :game_5, default: false
      t.boolean :game_6, default: false
      t.boolean :is_received_email, default: false
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
  end
end
