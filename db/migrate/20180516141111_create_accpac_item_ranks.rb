class CreateAccpacItemRanks < ActiveRecord::Migration[5.1]
  def change
    create_table :item_ranks, id: false do |t|
      t.string :item, null: false
      t.string :abc_sales_rank
      t.integer :dense_sales_rank
      t.string :abc_cost_rank
      t.integer :dense_cost_rank
      t.string :abc_margin_rank
      t.integer :dense_margin_rank

      t.timestamps
    end
    add_index :item_ranks, :item
  end
end
