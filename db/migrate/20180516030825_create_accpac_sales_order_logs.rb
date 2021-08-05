class CreateAccpacSalesOrderLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_order_logs do |t|
      t.string :item, null: false
      t.decimal :open_order_amount
      t.decimal :fulfillable_amount
      t.decimal :work_in_process_amount
      t.decimal :backorder_amount

      t.timestamps
    end
    add_index :sales_order_logs, :item
  end
end
