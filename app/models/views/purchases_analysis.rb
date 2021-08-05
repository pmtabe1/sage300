# This is a scenic view created to generate a report to analyzed 
# Purchases.
module Views
  class PurchasesAnalysis < ActiveRecord::Base

    self.table_name  = 'purchases_analysis'
    self.primary_key = 'ITEMNO'

    # Association with Sage300 tables (Vendors ans Items)
    belongs_to :apven, foreign_key: 'VENDOR', class_name: "Accpac::Apven"
    belongs_to :icitem, foreign_key: 'ITEMNO', class_name: "Accpac::Icitem"

  end
end
