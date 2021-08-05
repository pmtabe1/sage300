class CreateAdditionalCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :additional_costs do |t|
      t.integer :document_id
      t.string :addcost
      t.string :vendor
      t.decimal :amount, precision: 19, scale: 4
      t.integer :proration_method
      t.integer :reproration_method

      t.timestamps
    end

    add_index :additional_costs, :document_id
    add_index :additional_costs, :addcost
    add_index :additional_costs, :vendor
  end
end
