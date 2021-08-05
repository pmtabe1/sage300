# Sage300 table Location Details.
class Accpac::Iciloc < ActiveRecord::Base
  self.table_name  = 'ICILOC'
  self.primary_key = 'ITEMNO'

  # Association with Items and Locations.
  belongs_to :icitem, foreign_key: 'ITEMNO'
  belongs_to :icloc, foreign_key: 'LOCATION'
end
