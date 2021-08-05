class CreateClaim < ActiveRecord::Migration[5.1]
  def change
    create_table :claims do |t|
      t.string :uuid
      t.string :customer
      t.integer :user_id
      t.integer :follow_by
      t.string :invoice
      t.string :sales_order
      t.string :purchase_order
      t.string :item
      t.decimal :quantity, precision: 19, scale: 4
      t.string :subject
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
