class CreateInventoryDifferences < ActiveRecord::Migration[5.1]
  def change
    create_view :inventory_differences
  end
end
