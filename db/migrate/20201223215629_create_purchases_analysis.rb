class CreatePurchasesAnalysis < ActiveRecord::Migration[5.1]
  def change
    create_view :purchases_analysis
  end
end
