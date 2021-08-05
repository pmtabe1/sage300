class AddPorhseqToAdditionalCostLines < ActiveRecord::Migration[5.1]
  def change
    add_column :additional_cost_lines, :porhseq, :integer
    add_column :additional_cost_lines, :cost, :decimal, precision: 19, scale: 6
  end
end
