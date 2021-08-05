class CreateItemRankLocation < ActiveRecord::Migration[5.1]
  def change
    create_table :item_rank_locations do |t|
      t.string :location
      t.string :item
      t.string :abc_sales_rank
      t.integer :dense_sales_rank
      t.string :abc_cost_rank
      t.integer :dense_cost_rank
      t.string :abc_margin_rank
      t.integer :dense_margin_rank

      t.timestamps
    end
    add_index :item_rank_locations, :location
    add_index :item_rank_locations, :item
  end
end
