# ItemRanking is a sales performance tool that analyzes items 
# sales activity, and assigns up to 4 levels of rank. In the Ranking 
# Breakpoints we start with the Top customer and continuing with 
# successive next customers. We use OVER clause with functions to 
# compute aggregated values.
module Views
  class ItemRank < ActiveRecord::Base
    self.table_name  = 'items_rankings'
    self.primary_key = 'item'
    
    # Assocation with Sage300 items table.
    has_one :icitem, foreign_key: 'ITEM', class_name: "Accpac::Icitem"
  end
end
