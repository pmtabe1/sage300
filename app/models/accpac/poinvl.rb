# Sage300 table Invoice Lines.
class Accpac::Poinvl < ActiveRecord::Base
  self.table_name  = 'POINVL'
  self.primary_key = 'INVHSEQ'

  # Association with Invoices.
  belongs_to :poinvh1, foreign_key: 'INVHSEQ'
end
