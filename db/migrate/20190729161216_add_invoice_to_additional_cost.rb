class AddInvoiceToAdditionalCost < ActiveRecord::Migration[5.1]
  def change
    add_column :additional_costs, :invoice, :string
    add_column :additional_costs, :description, :string
  end
end
