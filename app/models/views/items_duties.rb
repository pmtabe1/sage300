# ItemsDuties is a scenic view. This is a simple SQL query 
# to put all the duties in one table.
module Views
  class ItemsDuties < ActiveRecord::Base

    self.table_name  = 'item_duties'
    self.primary_key = 'ITEMNO'

  end
end
