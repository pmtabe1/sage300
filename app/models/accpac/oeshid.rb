# Sage300 table Shipment Details.
class Accpac::Oeshid < ActiveRecord::Base
  self.table_name  = 'OESHID'
  self.primary_key = 'SHIUNIQ'

  # Association with Shipments.
  belongs_to :oeshih, foreign_key: 'SHIUNIQ'
end
