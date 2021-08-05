class CreateShippingReferenceFields < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_reference_fields do |t|
      t.string :name
      t.string :field_type
      t.boolean :required
      t.integer :shipping_reference_type_id
      t.string :document_column

      t.timestamps
    end
  end
end
