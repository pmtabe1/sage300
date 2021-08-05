# Sage300 table Purchase Order Lines.
class Accpac::Poporl < ActiveRecord::Base
  self.table_name  = 'POPORL'
  self.primary_key = 'PORHSEQ'

  # Association with 	Purchase Orders.
  belongs_to :poporh1, foreign_key: 'PORHSEQ'
  belongs_to :poporh2, foreign_key: 'PORHSEQ'
end
