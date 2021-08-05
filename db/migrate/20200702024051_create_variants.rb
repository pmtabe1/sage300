class CreateVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :variants do |t|
      t.string :sku
      t.decimal :weight, precision: 19, scale: 2
      t.decimal :height, precision: 19, scale: 2
      t.decimal :width, precision: 19, scale: 2
      t.decimal :depth, precision: 19, scale: 2
      t.boolean :is_master
      t.integer :product_id
      t.integer :position

      t.timestamps
    end
  end
end
