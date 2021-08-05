class CreateItemsRankings < ActiveRecord::Migration[5.1]
  def change
    create_view :items_rankings
  end
end
