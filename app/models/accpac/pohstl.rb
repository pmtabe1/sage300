# Sage300 table 	Purchase History Detail.
class Accpac::Pohstl < ActiveRecord::Base
  self.table_name  = 'POHSTL'
  self.primary_key = 'ITEMNO'

  # Association with Items and Vendors.
  belongs_to :icitem, foreign_key: 'ITEMNO'
  belongs_to :apven, foreign_key: 'VENDOR'
end
