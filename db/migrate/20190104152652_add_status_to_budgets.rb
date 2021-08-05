class AddStatusToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_column :budgets, :status, :string
  end
end
