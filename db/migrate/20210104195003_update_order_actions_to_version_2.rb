class UpdateOrderActionsToVersion2 < ActiveRecord::Migration[5.1]
  def change
    update_view :order_actions, version: 2, revert_to_version: 1
  end
end
