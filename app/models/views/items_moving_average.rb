# ItemsMovingAverage is a scenic view that calculate the Moving Average
# of items with sales in last 36 month. We use the OVER clause partition
# by items and locations.
module Views
  class ItemsMovingAverage < ActiveRecord::Base

    self.table_name  = 'item_moving_averages'
    self.primary_key = 'ITEMNO'
    
    # Association with Sage300 item table.
    belongs_to :icitem, foreign_key: 'ITEMNO'
  end
end
