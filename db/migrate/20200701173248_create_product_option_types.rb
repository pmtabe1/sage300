class CreateProductOptionTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :product_option_types do |t|
      t.integer :product_it
      t.integer :option_type_id
      t.integer :position

      t.timestamps
    end
  end
end
