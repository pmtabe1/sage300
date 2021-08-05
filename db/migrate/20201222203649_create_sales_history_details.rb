class CreateSalesHistoryDetails < ActiveRecord::Migration[5.1]
  def change
    create_view :sales_history_details
  end
end
