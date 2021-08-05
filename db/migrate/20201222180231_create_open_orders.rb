class CreateOpenOrders < ActiveRecord::Migration[5.1]
  def change
    create_view :open_orders
  end
end
