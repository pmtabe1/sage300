# ItemLocationDetail is a scenic view created to analyze items 
# availability by locations.
module Views
  class ItemLocationDetail < ActiveRecord::Base

    self.table_name  = 'items_location_details'
    self.primary_key = 'ITEMNO'

  end
end
