# CustomersRanking is a sales performance tool that analyzes customer 
# sales activity, and assigns up to 4 levels of rank. In the Ranking 
# Breakpoints we start with the Top customer and continuing with 
# successive next customers. We use OVER clause with functions to 
# compute aggregated values.
module Views
  class CustomersRanking < ActiveRecord::Base
    self.table_name  = 'customers_rankings'
    self.primary_key = 'CUSTOMER'
  
    # Association with Sage300 customers table.
    belongs_to :arcus, foreign_key: 'CUSTOMER', class_name: "Accpac::Arcus"
  end
end
