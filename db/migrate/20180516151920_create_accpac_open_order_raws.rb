class CreateAccpacOpenOrderRaws < ActiveRecord::Migration[5.1]
  def change
    create_table :open_order_raws do |t|
      t.string :item, null: false
      t.string :desciption
      t.integer :order_id, null: false
      t.string :order_number
      t.string :location
      t.string :customer_code, null: false
      t.string :customer_name
      t.string :customer_group
      t.string :territory
      t.string :sales_rep, null: false
      t.datetime :order_date
      t.decimal :qty_ordered, precision: 20, scale: 4
      t.decimal :qty_backorder, precision: 20, scale: 4
      t.decimal :qty_commit, precision: 20, scale: 4
      t.decimal :order_amount, precision: 38, scale: 4
      t.decimal :qty_location, precision: 20, scale: 4
      t.decimal :qty_company, precision: 38, scale: 4

      t.timestamps
    end
    add_index :open_order_raws, :order_id
    add_index :open_order_raws, :item
    add_index :open_order_raws, :customer_code
    add_index :open_order_raws, :sales_rep
  end
end
