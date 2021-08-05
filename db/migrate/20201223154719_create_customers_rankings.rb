class CreateCustomersRankings < ActiveRecord::Migration[5.1]
  def change
    create_view :customers_rankings
  end
end
