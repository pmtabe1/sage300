class AddItemnoToProductProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :product_properties, :itemno, :string
  end
end
