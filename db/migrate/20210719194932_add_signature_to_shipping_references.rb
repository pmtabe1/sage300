class AddSignatureToShippingReferences < ActiveRecord::Migration[5.1]
  def change
    add_column :shipping_references, :signature, :binary
    add_column :shipping_references, :signed_on, :datetime
  end
end
