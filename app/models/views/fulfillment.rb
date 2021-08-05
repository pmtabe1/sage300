# Fulfillment is a scenic view that list all fulfillments items 
# from sales orders.
module Views
  class Fulfillment < ActiveRecord::Base

    self.table_name  = 'fulfillments'

    # Scope to filter fulfillments by sales persons.
    scope :by_sales_person, lambda { |user| where(SALESREP: user.arsap) }

    # Association with Sage300 tables (Sales Persons and Customers).
    belongs_to :arsap, foreign_key: 'CODESLSP'
    belongs_to :arcus, foreign_key: 'IDCUST', class_name: "Arcus"
  end
end
