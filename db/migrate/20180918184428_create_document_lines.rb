class CreateDocumentLines < ActiveRecord::Migration[5.1]
  def change
    create_table :document_lines do |t|
      t.integer :document_id
      t.integer :porhseq
      t.string :itemno
      t.decimal :quantity, precision: 19, scale: 4
      t.decimal :price, precision: 19, scale: 4
      t.decimal :ext_price, precision: 19, scale: 4

      t.string :box_no
      t.decimal :gross_weight, precision: 19, scale: 4
      t.string :measure_gross_weight
      t.decimal :net_weight, precision: 19, scale: 4
      t.string :measure_net_weight
      t.decimal :volume, precision: 19, scale: 4
      t.string :measure_volume

      t.timestamps

      # Column to delete no longer in use
      t.json :preferences
    end
  end
end
