# Sage300 Account Group helper.
module Accpac::GlacgrpHelper
  # Set account group descriptions based on Sage300 Group Categories code.
  def account_groups_description(code)
    case code
    when 10
      'Cash & Cash Equivalents'
    when 20
      'Accouts Receivable'
    when 30
      'Inventory'
    when 40
      'Other Current Assets'
    when 50
      'Fixed Assets'
    when 60
      'Accumulated Depreciation'
    when 70
      'Other Assets'
    when 80
      'Accounts Payable'
    when 90
      'Other Current Liabilities'
    when 100
      'Long Liabilities'
    when 110
      'Other Liabilities'
    when 120
      'Share Capital'
    when 130
      'Shareholders Equity'
    when 140
      'Revenue'
    when 150
      'Cost of Sales'
    when 160
      'Other Revenue'
    when 170
      'Other Expenses'
    when 180
      'Depreciation Expense'
    when 190 
      'Gains/Losses'
    when 200 
      'Interest Expense'
    when 210
      'Income Taxes'
    end
  end

  # Define periods.
  def fiscal_set(r, period, year)
    case period
    when '01'
      r.glafs.jan(year)
    when '02'
      r.glafs.feb(year)
    when '03'
      r.glafs.mar(year)
    when '04'
      r.glafs.apr(year)
    when '05'
      r.glafs.may(year)
    when '06'
      r.glafs.jun(year)
    when '07'
      r.glafs.jul(year)
    when '08'
      r.glafs.aug(year)
    when '09'
      r.glafs.sep(year)
    when '10'
      r.glafs.oct(year)
    when '11'
      r.glafs.nov(year)
    when '12'
      r.glafs.dec(year)
    when 'ob'
      r.glafs.open_balance(year)
    end
  end

  def fical_set_variance(r, period, year)
    current = fiscal_set(r, period, year)
    last = fiscal_set(r, period, year.to_i-1)
    current - last
  end

  def fical_set_var_percentage(r, period, year)
    current = fiscal_set(r, period, year)
    last = fiscal_set(r, period, year.to_i-1)
    if last > 0
      var = (current/last)*100
    else
      var = (current/1)*100
    end
    if var-100 > 0
      "<div class='stat-percent font-bold text-danger'>
        #{number_to_percentage(var-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-info'>
        #{number_to_percentage(100-var, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def total_fical_set_percentage(last, current)
    var = (current/last)*100
    if var-100 > 0
      "<div class='stat-percent font-bold text-danger'>
        #{number_to_percentage(var-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-info'>
        #{number_to_percentage(100-var, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def revenue_variance
    last = Views::GeneralLedgerSummary.revenue.where("FSCSYR = ? AND FSPERD <= ?", last_year, current_period).sum("AMOUNT*-1")
    current = Views::GeneralLedgerSummary.revenue.where("FSCSYR = ? AND FSPERD <= ?", current_year, current_period).sum("AMOUNT*-1")
    var = (current/last)*100
    if var-100 > 0
      "<div class='stat-percent font-bold text-info'>
        #{number_to_percentage(var-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-danger'>
        #{number_to_percentage(100-var, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def cost_of_sales_variance
    last = Views::GeneralLedgerSummary.cost_of_sales.where("FSCSYR = ? AND FSPERD <= ?", last_year, current_period).sum("AMOUNT*-1")
    current = Views::GeneralLedgerSummary.cost_of_sales.where("FSCSYR = ? AND FSPERD <= ?", current_year, current_period).sum("AMOUNT*-1")
    var = (current/last)*100
    if var-100 > 0
      "<div class='stat-percent font-bold text-info'>
        #{number_to_percentage(var-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-danger'>
        #{number_to_percentage(100-var, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def expenses_variance
    last = Views::GeneralLedgerSummary.expenses.where("FSCSYR = ? AND FSPERD <= ?", last_year, current_period).sum("AMOUNT*-1")
    current = Views::GeneralLedgerSummary.expenses.where("FSCSYR = ? AND FSPERD <= ?", current_year, current_period).sum("AMOUNT*-1")
    var = (current/last)*100
    if var-100 > 0
      "<div class='stat-percent font-bold text-danger'>
        #{number_to_percentage(var-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-info'>
        #{number_to_percentage(100-var, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  def net_income_variance
    last = Views::GeneralLedgerSummary.net_income.where("FSCSYR = ? AND FSPERD <= ?", last_year, current_period).sum("AMOUNT*-1")
    current = Views::GeneralLedgerSummary.net_income.where("FSCSYR = ? AND FSPERD <= ?", current_year, current_period).sum("AMOUNT*-1")
    var = (current/last)*100
    if var-100 > 0
      "<div class='stat-percent font-bold text-info'>
        #{number_to_percentage(var-100, precision: 2)} <i class='fa fa-level-up'></i>
      </div>".html_safe
    else
      "<div class='stat-percent font-bold text-danger'>
        #{number_to_percentage(100-var, precision: 2)} <i class='fa fa-level-down'></i>
      </div>".html_safe
    end
  end

  # Total paymewnts received by customer during current year.
  def cash_received_from_customers
    Accpac::Arcsm.where(CNTYR: current_year).sum("AMTPAYMHC*-1")
  end

  # Total payments to vendors during the current year.
  def paid_to_vendors
    Accpac::Apvsm.where(CNTYR: current_year).sum(:AMTINVPDHC)
  end
  
  # Total payments to vendors during the current year.
  # Special method for Vertisol Mexico, excluding TRASPASOS vendor.
  def cash_paid_to_vendors
    Accpac::Apvsm.find_by_sql("
      SELECT vg.GROUPID, vg.DESCRIPTN, SUM(vs.AMTINVPDHC) AS AMTINVPDHC
      FROM APVGR vg
      JOIN APVEN v ON vg.GROUPID = v.IDGRP
      JOIN APVSM vs ON vs.VENDORID = v.VENDORID
      WHERE vs.CNTYR = #{current_year}
      AND v.VENDORID <> 'TRASPASOS'
      GROUP BY vg.GROUPID, vg.DESCRIPTN
    ")
  end

  # Revenue sparkline chart to visualize increase/decrease during the last five years.
  def sparkline_revenue
    (5.years.ago.to_date.year..Time.now.year).map do |year|
      Views::GeneralLedgerSummary.revenue.where("FSCSYR = ? AND FSPERD <= ?", year, current_period).order(FSCSYR: :asc).sum("AMOUNT*-1").to_i
    end
  end

  # Net Income sparkline chart to visualize increase/decrease during the last five years.
  def sparkline_net_income
    (5.years.ago.to_date.year..Time.now.year).map do |year|
      Views::GeneralLedgerSummary.net_income.where("FSCSYR = ? AND FSPERD <= ?", year, current_period).order(FSCSYR: :asc).sum("AMOUNT*-1").to_i
    end
  end

  # Cost of Good Sold sparkline chart to visualize increase/decrease during the last five years.
  def sparkline_cost_of_sales
    (5.years.ago.to_date.year..Time.now.year).map do |year|
      Views::GeneralLedgerSummary.cost_of_sales.where("FSCSYR = ? AND FSPERD <= ?", year, current_period).order(FSCSYR: :asc).sum("AMOUNT").to_i
    end
  end

  # Expenses sparkline chart to visualize increase/decrease during the last five years.
  def sparkline_expenses
    (5.years.ago.to_date.year..Time.now.year).map do |year|
      Views::GeneralLedgerSummary.expenses.where("FSCSYR = ? AND FSPERD <= ?", year, current_period).order(FSCSYR: :asc).sum("AMOUNT").to_i
    end
  end
end
