# Sage300 tbale Order Comments/Instructions.
class Accpac::Oecoino < ActiveRecord::Base
  self.table_name  = 'OECOINO'
  self.primary_key = 'ORDUNIQ'

  # Association with Sales Orders.
  belongs_to :oeordh, foreign_key: 'ORDUNIQ'
end
