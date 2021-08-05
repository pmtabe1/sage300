class CreateAdditionalCostLines < ActiveRecord::Migration[5.1]
  def change
    create_table :additional_cost_lines do |t|
      t.integer :additional_cost_id
      t.integer :document_id
      t.string :itemno
      t.string :formatted_itemno
      t.decimal :amount, precision: 19, scale: 4

      t.timestamps
    end

    add_index :additional_cost_lines, :document_id
    add_index :additional_cost_lines, :itemno
  end
end
