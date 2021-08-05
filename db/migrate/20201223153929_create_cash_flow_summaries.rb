class CreateCashFlowSummaries < ActiveRecord::Migration[5.1]
  def change
    create_view :cash_flow_summaries
  end
end
