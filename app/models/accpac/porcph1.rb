# Sage300 table Receipts.
class Accpac::Porcph1 < ActiveRecord::Base
  self.table_name  = 'PORCPH1'
  self.primary_key = 'RCPHSEQ'

  # Association with Receipt Lines, Receipt Additional Costs, Purchase Order Lines and Purchase Orders.
  has_many :porcpl, foreign_key: 'RCPHSEQ'
  has_many :poporh1, foreign_key: 'PORHSEQ'
  has_many :poporl, through: :poporh1
  has_many :porcps, foreign_key: 'RCPHSEQ', class_name: 'Porcps'
  belongs_to :apven, foreign_key: 'VDCODE'

  # Scopes to filter by incomplete and vendors.
  scope :open, ->{ where("ISCOMPLETE = ?", 0) }
  scope :by_vendor, lambda { |user| where(VDCODE: user.vendor_id) }
end
