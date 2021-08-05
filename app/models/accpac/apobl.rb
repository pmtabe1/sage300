# Sage300 Accounts Payable Documents table.
# Primary key: IDVEND (Vendor Number).
class Accpac::Apobl < ActiveRecord::Base
  self.table_name  = 'APOBL'
  self.primary_key = 'IDVEND'

  # Association with vendor table.
  belongs_to :apven, foreign_key: 'VENDORID'
end
