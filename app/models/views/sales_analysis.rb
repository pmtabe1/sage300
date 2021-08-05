# This is a scenic view created to generate a report to analyzed 
# Sales. This view is based on the sales_analysis_details.
module Views
  class SalesAnalysis < ActiveRecord::Base
    # Filterable concerns model applying filters.
    include Filterable

    self.table_name  = 'sales_analyses'
    self.primary_key = 'ITEMNO'

    # Association with Sage300 tables (Customers and Items)
    belongs_to :arcus, foreign_key: 'CUSTOMER', class_name: "Accpac::Arcus"
    belongs_to :icitem, foreign_key: 'ITEMNO'

    # Scope to filter by sales person using lambda function.
    scope :by_sales_rep, lambda { |user| where("CODESLSP1 = ? OR CODESLSP2 = ? OR CODESLSP3 = ?", user, user, user) }
  end
end
