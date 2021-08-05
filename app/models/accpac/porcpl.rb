# Sage300 table Receipt Lines.
class Accpac::Porcpl < ActiveRecord::Base
  self.table_name  = 'PORCPL'
  self.primary_key = 'RCPHSEQ'

  # Association with Receipts, Purchase Orders and 	Purchase Order Lines.
  belongs_to :porcph1, foreign_key: 'RCPHSEQ'
  belongs_to :poporh1, foreign_key: 'PORHSEQ'
  belongs_to :poporl, foreign_key: 'PORLSEQ'
end
