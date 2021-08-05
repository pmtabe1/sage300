class CreateItemMovingAverages < ActiveRecord::Migration[5.1]
  def change
    create_view :item_moving_averages
  end
end
