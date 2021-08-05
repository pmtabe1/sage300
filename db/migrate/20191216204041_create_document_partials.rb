class CreateDocumentPartials < ActiveRecord::Migration[5.1]
  def change
    create_table :document_partials do |t|
      t.integer :document_id
      t.string :purchase_order
      t.string :vendor
      t.string :item
      t.decimal :original_qty, precision: 19, scale: 4
      t.decimal :packed_qty, precision: 19, scale: 4
      t.decimal :remain_qty, precision: 19, scale: 4
      t.date :original_etd
      t.date :current_etd
      t.boolean :complete
      t.json :properties

      t.timestamps
    end
  end
end
