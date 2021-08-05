class CreateShippingReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_references do |t|
      t.string :number
      t.string :customer
      t.string :location
      t.string :shipvia
      t.text :description
      t.string :status
      t.integer :user_id
      t.integer :shipping_reference_type_id
      t.boolean :updated
      t.boolean :printed
      t.boolean :completed

      t.timestamps
    end
  end
end
