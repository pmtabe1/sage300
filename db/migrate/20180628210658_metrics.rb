class Metrics < ActiveRecord::Migration[5.1]
  def change
    create_table :metrics do |t|
      t.string :name
      t.string :description
      t.text :statement
      t.integer :user_id

      t.timestamps
    end
  end
end
