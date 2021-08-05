# GeneralLedgerSummary is a scenic view generated to group Accounts, 
# Account Groups and fiscal_sets (Unpivot Account Fiscal Sets) to 
# create Finanacial Statements.
module Views
  class GeneralLedgerSummary < ActiveRecord::Base
    # Filterable concerns model applying filters.
    include Filterable

    self.table_name  = 'general_ledger_summaries'
    self.primary_key = 'ACCTID'
    
    # List of scopes to group account by segments.
    scope :net_income, -> { where("GRPCOD IN (140,150,160,170,180,190,200)") }
    scope :cost_of_sales, -> { where("GRPCOD IN (150)") }
    scope :expenses, -> { where("GRPCOD IN (170,180,190,200)") }
    scope :revenue, -> { where("GRPCOD IN (140,160)") }
    scope :current_assets, -> { where("GRPCOD IN (10,20,30,40)").order(GRPCOD: :asc) }
    scope :current_liabilities, -> { where("GRPCOD IN (80,90)").order(GRPCOD: :asc) }

    # Scopes to filters statements.
    scope :last_5_years, -> { where(FSCSYR: 5.years.ago.strftime("%Y")..Time.now.strftime("%Y")).where("DATE <= ?", Time.now.end_of_month.strftime("%Y-%m-%d")) }
    scope :by_years, -> { where(FSCSYR: 5.years.ago.strftime("%Y")..Time.now.strftime("%Y")) }
    scope :start_date, -> (start_date) { where("DATE >= ?", start_date.to_date.strftime("%Y-%m-%d")) }
    scope :end_date, -> (end_date) { where("DATE <= ?", end_date.to_date.strftime("%Y-%m-%d")) }
  end
end
