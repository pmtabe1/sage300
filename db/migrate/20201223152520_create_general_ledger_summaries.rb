class CreateGeneralLedgerSummaries < ActiveRecord::Migration[5.1]
  def change
    create_view :general_ledger_summaries
  end
end
