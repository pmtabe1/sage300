# Sage300 table	Internal Usage Details.
class Accpac::Iciced < ActiveRecord::Base
  self.table_name  = 'ICICED'
  self.primary_key = 'SEQUENCENO'

  belongs_to :iciceh, foreign_key: 'SEQUENCENO'
end
