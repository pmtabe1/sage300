# Sage300 table Receipts.
class Accpac::Porcph2 < ActiveRecord::Base
  self.table_name  = 'PORCPH2'
  self.primary_key = 'RCPHSEQ'

  # Association with Receipts main header and Receipt Lines.
  has_many :porcph1, foreign_key: 'RCPHSEQ'
  has_many :porcpl, through: :porcph1
end
