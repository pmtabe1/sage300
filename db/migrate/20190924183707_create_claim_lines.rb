class CreateClaimLines < ActiveRecord::Migration[5.1]
  def change
    create_table :claim_lines do |t|
      t.integer :claim_id
      t.string :invoice
      t.string :sales_order
      t.string :item
      t.decimal :quantity, precision: 19, scale: 4

      t.timestamps
    end
  end
end
