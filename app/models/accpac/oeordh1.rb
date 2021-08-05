# Sage300 table Orders (header 1)
class Accpac::Oeordh1 < ActiveRecord::Base
  self.table_name  = 'OEORDH1'
  self.primary_key = 'ORDUNIQ'

  # Associatoin with Order Details and main Order header.
  has_many :oeordd, foreign_key: 'ORDUNIQ'
  has_one :oeordh, foreign_key: 'ORDUNIQ'
end
