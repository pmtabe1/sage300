# Sage300 table Additional Costs.
class Accpac::Poacst < ActiveRecord::Base
  self.table_name  = 'POACST'
  self.primary_key = 'ADDCOST'

  # Scope to filter only active Additional Costs.
  scope :active, ->{ where(INACTIVE: 0) }
end
