# Sage300 table Locations.
class Accpac::Icloc < ActiveRecord::Base
  self.table_name  = 'ICLOC'
  self.primary_key = 'LOCATION'

  # Assocation with Items, Sales Orders and Invoices.
  has_many :iciloc, foreign_key: 'LOCATION'
  has_many :location, foreign_key: 'ERPLocation'
  has_many :oeordh, foreign_key: 'LOCATION'
  has_many :oeinvh, foreign_key: 'LOCATION'
end
