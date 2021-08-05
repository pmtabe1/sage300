# Sage300 table Item Tax Authorities.
class Accpac::Icitmtx < ActiveRecord::Base
  self.table_name  = 'ICITMTX'
  self.primary_key = 'ITEMNO'

  # Association with Items.
  has_many :icitemo, foreign_key: 'ITEMNO'
end
