class CreateRandomNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :random_numbers do |t|
      t.integer :number
      t.timestamps
    end
  end
end
