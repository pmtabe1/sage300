class CreateSalesAnalysisDetails < ActiveRecord::Migration[5.1]
  def change
    create_view :sales_analysis_details
  end
end
