class AddSignedByToShippingReferences < ActiveRecord::Migration[5.1]
  def change
    add_column :shipping_references, :signed_by, :string
  end
end
