# ItemRankingLocation is a sales performance tool that analyzes items 
# sales activity by locations, and assigns up to 4 levels of rank.
module Views
  class ItemRankLocation < ActiveRecord::Base
    self.table_name  = 'items_ranking_locations'
    self.primary_key = 'item'

    # Association with Sage300 Items table.
    belongs_to :icitem, foreign_key: 'ITEM'
  end
end
