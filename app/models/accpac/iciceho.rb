# Sage300 table Internal Usage Detail Optional Fields.
class Accpac::Iciceho < ActiveRecord::Base
  self.table_name  = 'ICICEHO'
  self.primary_key = 'SEQUENCENO'

  belongs_to :iciceh, foreign_key: 'SEQUENCENO'
end
