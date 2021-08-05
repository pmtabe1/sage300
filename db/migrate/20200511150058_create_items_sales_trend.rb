class CreateItemsSalesTrend < ActiveRecord::Migration[5.1]
  def change
    create_table :items_sales_trend do |t|
      t.string :customer
      t.string :item
      t.string :opt_category
      t.string :opt_product
      t.string :opt_type
      t.string :category
      t.decimal :current_average, precision: 19, scale: 6
      t.decimal :past_average, precision: 19, scale: 6
      t.integer :sales_period
      t.date :last_period
      t.decimal :p_value, precision: 19, scale: 6
      t.boolean :significant
      t.string :trend

      t.timestamps
    end
  end
end
