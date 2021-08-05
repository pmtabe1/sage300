class CreateTableItemsSalesTrend < ActiveRecord::Migration[5.1]
  def change
    create_table :items_sales_trends do |t|
      t.string :itemno
      t.string :opt_field_cat
      t.string :opt_fiedl_product
      t.string :opt_field_type
      t.string :category
      t.integer :ave_purchase_period
      t.integer :n_period
      t.string :last_sales_period
      t.decimal :current_ytd_netsales, precision: 19, scale: 6
      t.decimal :past_ytd_netsales, precision: 19, scale: 6
      t.decimal :ytd_difference_netsales, precision: 19, scale: 6
      t.decimal :current_ave_netsales, precision: 19, scale: 6
      t.decimal :past_ave_netsales, precision: 19, scale: 6
      t.decimal :diff_netsales, precision: 19, scale: 6
      t.boolean :significant_netsales
      t.string :trend_netsales
      t.decimal :current_ytd_margin, precision: 19, scale: 6
      t.decimal :past_ytd_margin, precision: 19, scale: 6
      t.decimal :ytd_difference_margin, precision: 19, scale: 6
      t.decimal :current_ave_margin, precision: 19, scale: 6
      t.decimal :past_ave_margin, precision: 19, scale: 6
      t.decimal :diff_margin, precision: 19, scale: 6
      t.boolean :significant_margin
      t.string :trend_margin

      t.timestamps
    end
  end
end
