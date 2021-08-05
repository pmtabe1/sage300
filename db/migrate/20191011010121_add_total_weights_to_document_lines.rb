class AddTotalWeightsToDocumentLines < ActiveRecord::Migration[5.1]
  def change
    add_column :document_lines, :total_gross_weight, :decimal, precision: 19, scale: 4
    add_column :document_lines, :total_net_weight, :decimal, precision: 19, scale: 4
  end
end
