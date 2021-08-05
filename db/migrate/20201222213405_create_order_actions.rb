class CreateOrderActions < ActiveRecord::Migration[5.1]
  def change
    create_view :order_actions
  end
end
