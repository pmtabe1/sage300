# Sage300 table Units of Measure.
class Accpac::Icunit < ActiveRecord::Base
  self.table_name  = 'ICUNIT'
  self.primary_key = 'ITEMNO'

  # Association with Items
  belongs_to :icitem, foreign_key: 'ITEMNO'
end
