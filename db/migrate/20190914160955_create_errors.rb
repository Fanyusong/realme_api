class CreateErrors < ActiveRecord::Migration[5.2]
  def change
    create_table :errors do |t|
      t.text :message
      t.timestamps
    end
  end
end
