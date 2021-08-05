class CreateOptionValuesVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :option_values_variants do |t|
      t.integer :variant_id
      t.integer :option_value_id

      t.timestamps
    end
  end
end
