class CreatePaymentLine < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_lines do |t|
      t.integer :payment_id
      t.string :invoice
      t.decimal :amount, precision: 19, scale: 3

      t.timestamps
    end
  end
end
