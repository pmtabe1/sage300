 module Views 
  class OpenOrderRaw < ActiveRecord::Base
    self.table_name  = 'open_order_raws'
    self.primary_key = 'item'
  end
end
