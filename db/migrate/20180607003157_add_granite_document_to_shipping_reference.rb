class AddGraniteDocumentToShippingReference < ActiveRecord::Migration[5.1]
  def change
    add_column :shipping_references, :granite_document, :text
  end
end
