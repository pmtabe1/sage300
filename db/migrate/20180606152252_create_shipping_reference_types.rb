class CreateShippingReferenceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_reference_types do |t|
      t.string :name
      t.string :hex

      t.timestamps
    end
  end
end
