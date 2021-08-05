class CreateDiffIcilocOrders < ActiveRecord::Migration[5.1]
  def change
    create_view :diff_iciloc_orders
  end
end
