class Accpac::GlacgrpController < ApplicationController
  before_action :set_accpac_glacgrp, only: [:show]
  before_action :set_instances, only: [:trial_balance, :balance_sheet, :income_statement, :cash_flow_statement, 
    :liquidity, :leverage, :efficiency, :receivable, :profitability, :expenses]

  def index
    @accpac_glacgrp = Accpac::Glacgrp.active
  end

  def show
  end

  def trial_balance
    @accpac_glacgrp = Accpac::Glacgrp.active
    respond_to do |format|
      format.js
      format.xls
    end
  end

  def balance_sheet
    respond_to do |format|
      format.js
    end
  end

  def income_statement
    respond_to do |format|
      format.js
    end
  end

  def cash_flow_statement
    respond_to do |format|
      format.js
    end
  end

  def fiscal_sets
    @fiscal_sets = Accpac::Glacgrp.find_by_sql("
      SELECT
        g.ACCTGRPCOD, g.ACCTGRPDES, g.GRPCOD, a.ACCTID, a.ACCTDESC, 
        CASE a.ACCTTYPE
          WHEN 'I' THEN 'Income Statement'
          WHEN 'B' THEN 'Balance Sheet'
          WHEN 'R' THEN 'Retained Earnings'
        END AS ACCTTYPE,
        CASE a.ACTIVESW
          WHEN 0 THEN 'Inactive'
          WHEN 1 THEN 'Active'
        END AS ACTIVESW,
        fs.FSCSYR, fs.OPENBAL, fs.NETPERD1, fs.NETPERD2,
        fs.NETPERD3, fs.NETPERD4, fs.NETPERD5, fs.NETPERD6,
        fs.NETPERD7, fs.NETPERD8, fs.NETPERD9, fs.NETPERD10,
        fs.NETPERD11, fs.NETPERD12, 
        CASE fs.CURNTYPE
          WHEN 'S' THEN 'Source'
          WHEN 'E' THEN 'Equivalent'
          WHEN 'F' THEN 'Functional'
        END AS CURNTYPE
      FROM GLACGRP g
      JOIN GLAMF a ON g.ACCTGRPCOD = a.ACCTGRPCOD
      JOIN GLAFS fs ON a.ACCTID = fs.ACCTID
      WHERE FSCSYR >= (YEAR(GETDATE())-5)
      ORDER BY FSCSYR DESC
    ")
    respond_to do |format|
      format.html
      format.json
    end
  end

  def liquidity
    respond_to do |format|
      format.js
    end
  end

  def leverage
    respond_to do |format|
      format.js
    end
  end

  def efficiency
    respond_to do |format|
      format.js
    end
  end

  def profitability
    respond_to do |format|
      format.js
    end
  end

  def receivable
    respond_to do |format|
      format.js
    end
  end

  def expenses
    respond_to do |format|
      format.js
    end
  end

  def chart_expenses
    respond_to do |format|
      format.js
    end
  end

  private
    def set_accpac_glacgrp
      @accpac_glacgrp = Accpac::Glacgrp.find(params[:id])
    end

    def set_instances
      @cash_equivalents = Accpac::Glacgrp.cash_equivalents
      @current_assets = Accpac::Glacgrp.current_assets
      @fixed_assets = Accpac::Glacgrp.fixed_assets
      @other_assets = Accpac::Glacgrp.other_assets
      @depreciation = Accpac::Glacgrp.depreciation
      @inventory = Accpac::Glacgrp.inventory
      @accounts_receivable = Accpac::Glacgrp.accounts_receivable

      @current_liabilities = Accpac::Glacgrp.current_liabilities
      @long_term_liabilities = Accpac::Glacgrp.long_term_liabilities
      @other_liabilities = Accpac::Glacgrp.other_liabilities

      @equity = Accpac::Glacgrp.equity
      @profit_loss = Accpac::Glacgrp.profit_loss
    
      @revenue = Accpac::Glacgrp.revenue
      @cost_of_sales = Accpac::Glacgrp.cost_of_sales
      @expenses = Accpac::Glacgrp.expenses
      @income_taxes = Accpac::Glacgrp.income_taxes

      @salaries = Accpac::Glacgrp.salaries
      @interest = Accpac::Glacgrp.interest
    end
end
