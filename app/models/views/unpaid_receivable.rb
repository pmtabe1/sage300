# This is a scenic view to lists all pending (unpaid) documents by customers.
module Views
  class UnpaidReceivable < ActiveRecord::Base

    self.table_name  = 'un_paid_receivables'
    #self.primary_key = 'IDCUST'

    # Scopes to order debts by terms (30, 60, 80 and more than 90 days)
    scope :u30, -> { where("TERMDAYSOVER > 0 AND TERMDAYSOVER <= 30") }
    scope :u60, -> { where("TERMDAYSOVER > 30 AND TERMDAYSOVER <= 60") }
    scope :u90, -> { where("TERMDAYSOVER > 60 AND TERMDAYSOVER <= 90") }
    scope :m90, -> { where("TERMDAYSOVER > 90") }

    # Association with Sage300 vendor table.
    belongs_to :arcus, foreign_key: 'IDCUST', class_name: "Arcus"

  end
end
