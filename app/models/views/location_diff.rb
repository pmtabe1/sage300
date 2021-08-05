# This is a scenic view created to identify differences between 
# quantity on sales order (QTYORDERED) and quantity committed (QTYCOMMIT) 
# on sales orders and location tables.
module Views
  class LocationDiff < ActiveRecord::Base

    self.table_name  = 'location_differences'
    self.primary_key = 'ITEMNO'

    scope :diff, -> { where("QTYSALORDR <> ORDEREDOE OR QTYCOMMIT <> ORDCOMMIT") }

  end
end
