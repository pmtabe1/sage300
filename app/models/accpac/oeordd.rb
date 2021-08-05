# Sahe300 table Order Details.
class Accpac::Oeordd < ActiveRecord::Base
  self.table_name  = 'OEORDD'
  self.primary_key = 'ORDUNIQ'

  # Association with Sales Oorder Headers.
  belongs_to :oeordh, foreign_key: 'ORDUNIQ'
end
