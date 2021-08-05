class UpdateOpenOrdersToVersion2 < ActiveRecord::Migration[5.1]
  def change
    update_view :open_orders, version: 2, revert_to_version: 1
  end
end
