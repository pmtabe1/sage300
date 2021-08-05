# Sage300 table Vendor Item Numbers.
class Accpac::Icitmv < ActiveRecord::Base
  self.table_name  = 'ICITMV'
  self.primary_key = 'ITEMNO'

  # Association with Vendors and Items
  belongs_to :icitem, foreign_key: 'ITEMNO'
  belongs_to :apven, foreign_key: 'VENDORID'
  
  # Scope to filter by vendors.
  scope :by_vendor, lambda { |user| where(VENDNUM: user.vendor_id) }
end
