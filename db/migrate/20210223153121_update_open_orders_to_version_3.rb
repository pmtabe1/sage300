class UpdateOpenOrdersToVersion3 < ActiveRecord::Migration[5.1]
  def change
    update_view :open_orders, version: 3, revert_to_version: 2
  end
end
