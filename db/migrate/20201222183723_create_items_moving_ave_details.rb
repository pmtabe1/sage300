class CreateItemsMovingAveDetails < ActiveRecord::Migration[5.1]
  def change
    create_view :items_moving_ave_details
  end
end
