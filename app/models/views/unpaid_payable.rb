# This is a scenic view to lists all pending (unpaid) documents by vendors.
module Views
  class UnpaidPayable < ActiveRecord::Base

    self.table_name  = 'un_paid_payables'
    #self.primary_key = 'IDCUST'

    # Scopes to order debts by terms (30, 60, 80 and more than 90 days)
    scope :u30, -> { where("TERMDAYSOVER > 0 AND TERMDAYSOVER <= 30") }
    scope :u60, -> { where("TERMDAYSOVER > 30 AND TERMDAYSOVER <= 60") }
    scope :u90, -> { where("TERMDAYSOVER > 60 AND TERMDAYSOVER <= 90") }
    scope :m90, -> { where("TERMDAYSOVER > 90") }
    
    # Association with Sage300 vendor table.
    belongs_to :apven, foreign_key: 'VENDORID', class_name: "Accpac::Apven"
  end
end
