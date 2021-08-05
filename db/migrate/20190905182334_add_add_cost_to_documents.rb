class AddAddCostToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :add_cost_description, :string
    add_column :documents, :add_cost, :decimal, precision: 19, scale: 2
  end
end
