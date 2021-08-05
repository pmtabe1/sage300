class UpdateOrderActionsToVersion3 < ActiveRecord::Migration[5.1]
  def change
    update_view :order_actions, version: 3, revert_to_version: 2
  end
end
