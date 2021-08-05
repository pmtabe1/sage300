class Query < ActiveRecord::Base
  validates :name, :description, :statement, presence: true
  has_many :widget_queries, dependent: :destroy
  has_many :widgets, through: :widget_queries

  # Friendly Id 
  #
  # It lets you create pretty URLs and work with human-friendly strings associated
  # if they were numeric ids.
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  # Module are the Sage300 modules to be associated with the query.
  MODULE = [
    "AP", # Accounts Payable
    "AR", # Accounts Receivable
    "GL", # Genral Ledger
    "IC", # Inventory Control
    "OE", # Order Entry
    "PO", # Purchase Order
    "WM"  # Warehouse Management
  ]
end
