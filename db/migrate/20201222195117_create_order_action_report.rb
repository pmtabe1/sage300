class CreateOrderActionReport < ActiveRecord::Migration[5.1]
  def change
    create_view :order_action_report
  end
end
