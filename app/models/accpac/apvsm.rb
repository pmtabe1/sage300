# Sage300 Vendor Statistics table.
# Primary key: VENDORID (Vendor Number).
class Accpac::Apvsm < ActiveRecord::Base
  self.table_name  = 'APVSM'
  self.primary_key = 'VENDORID'

  # Association with vendor table.
  belongs_to :apven, foreign_key: 'VENDORID'
end
