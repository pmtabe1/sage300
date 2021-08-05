# Sage300 table Purchase Order Invoices
class Accpac::Poinvh1 < ActiveRecord::Base
  self.table_name  = 'POINVH1'
  self.primary_key = 'INVHSEQ'

  # association with Invocie Header2, Invoice Lines and Vendors.
  has_one :poinvh2, foreign_key: 'INVHSEQ'
  has_many :poinvl, foreign_key: 'INVHSEQ'
  belongs_to :apven, foreign_key: 'VDCODE'
  
  # Scope to filter only incomplete invoices.
  scope :not_complete, ->{ where(ISCOMPLETE: 0) }
end
