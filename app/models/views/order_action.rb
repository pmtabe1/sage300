# This is a scenic view that analyzes all open orders. Include rankings, 
# references status, margins, etc.
module Views
  class OrderAction < ActiveRecord::Base

    self.table_name  = 'order_actions'
    self.primary_key = 'ORDUNIQ'

    # Scope with filtes by sales persons and References stages:
    # - Work in Process 
    # - Fulfillable 
    # - Backorders
    scope :backorder, -> { where("BACKORDQTY > ?", 0) }

    # Association with Sage300 tables (Sales Person, Customers, Items)
    belongs_to :arsap, foreign_key: 'SALESREP'
    belongs_to :arcus, foreign_key: 'CUSTOMER', class_name: "Arcus"
    belongs_to :icitem, foreign_key: 'ITEM'

  end
end
