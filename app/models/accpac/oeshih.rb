# Sage300 table Shipments.
class Accpac::Oeshih < ActiveRecord::Base
  self.table_name  = 'OESHIH'
  self.primary_key = 'SHIUNIQ'

  # Association with Shipment Details, Customers and Locations.
  has_many :oeshid, foreign_key: 'SHIUNIQ'
  belongs_to :arcus, foreign_key: 'CUSTOMER', class_name: "Arcus"
  belongs_to :icloc, foreign_key: 'LOCATION'
end
