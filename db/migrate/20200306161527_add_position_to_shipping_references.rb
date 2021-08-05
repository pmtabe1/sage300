class AddPositionToShippingReferences < ActiveRecord::Migration[5.1]
  def change
    add_column :shipping_references, :position, :integer
  end
end
