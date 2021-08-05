# ItemCompanyDetail is a scenic view created to analyze items 
# availability in all physical locations.
module Views
  class ItemCompanyDetail < ActiveRecord::Base

    self.table_name  = 'item_company_details'
    self.primary_key = 'ITEMNO'
    
    # Scope for A items with low stock (meaning less that 4.5 months).
    scope :low_stock_a_items, ->{ where("COVERAGE < ? AND QTYONORDER = ? AND PRODUCTION = ? AND abc_sales_rank = ?", 4.5, 0, 0, 'A') }
  end
end
