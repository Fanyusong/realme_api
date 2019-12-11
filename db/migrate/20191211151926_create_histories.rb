class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.string :description
      t.string :type
      t.timestamps
    end
  end
end
