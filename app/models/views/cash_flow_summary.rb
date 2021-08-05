# CashFlowSummary is a scenic view created to calculate the 
# operating cash flow with Direc Method and group it by years/period.
module Views
  class CashFlowSummary < ActiveRecord::Base

    self.table_name  = 'cash_flow_summaries'
    self.primary_key = 'CNTYR'

    # These scopes filter the operating cash flow for last year and 
    # las 2 years.
    scope :last_1_years, -> { where(CNTYR: 1.years.ago.strftime("%Y")..Time.now.strftime("%Y")) }
    scope :last_2_years, -> { where(CNTYR: 2.years.ago.strftime("%Y")..Time.now.strftime("%Y")) }
  end
end
