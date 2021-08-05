# Sage300 table Internal Usage Headers.
class Accpac::Iciceh < ActiveRecord::Base
  self.table_name  = 'ICICEH'
  self.primary_key = 'SEQUENCENO'

  has_many :iciced, foreign_key: 'SEQUENCENO'
  has_many :iciceho, foreign_key: 'SEQUENCENO'
end
