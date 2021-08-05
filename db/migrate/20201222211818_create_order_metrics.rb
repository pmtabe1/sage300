class CreateOrderMetrics < ActiveRecord::Migration[5.1]
  def change
    create_view :order_metrics
  end
end
