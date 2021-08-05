# Sage300 table Receipt Additional Costs.
class Accpac::Porcps < ActiveRecord::Base
  self.table_name  = 'PORCPS'
  self.primary_key = 'RCPHSEQ'

  # Association with Receipts.
  belongs_to :porcph1, foreign_key: 'RCPHSEQ'
end
