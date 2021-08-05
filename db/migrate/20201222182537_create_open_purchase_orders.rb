class CreateOpenPurchaseOrders < ActiveRecord::Migration[5.1]
  def change
    create_view :open_purchase_orders
  end
end
