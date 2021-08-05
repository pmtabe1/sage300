class AddUserAndCustomerToShippingReferences < ActiveRecord::Migration[5.1]
  def change
    add_column :shipping_references, :user_name, :string
    add_column :shipping_references, :customer_name, :string
  end
end
