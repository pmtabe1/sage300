class AddListIdToShippingReferences < ActiveRecord::Migration[5.1]
  def change
    add_column :shipping_references, :list_id, :integer
  end
end
