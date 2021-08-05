class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.integer :variant_id
      t.decimal :amount, precision: 19, scale: 2
      t.string :currency
      t.string :country
      t.string :region

      t.timestamps
    end
  end
end
