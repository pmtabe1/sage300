class CreateSalesAnalyses < ActiveRecord::Migration[5.1]
  def change
    create_view :sales_analyses
  end
end
