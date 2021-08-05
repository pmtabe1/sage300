class CreateItemsRankingLocations < ActiveRecord::Migration[5.1]
  def change
    create_view :items_ranking_locations
  end
end
