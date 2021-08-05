# Sage300 table Manufacturer's Item Number.
class Accpac::Icioth < ActiveRecord::Base
  self.table_name  = 'ICIOTH'
  self.primary_key = 'ITEMNO'

  # Association with Items.
  belongs_to :icitem, foreign_key: 'ITEMNO'
end
