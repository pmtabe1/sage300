class AddDepartmentsToShippingReferences < ActiveRecord::Migration[5.1]
  def change
    add_column :shipping_references, :departments, :json
  end
end
