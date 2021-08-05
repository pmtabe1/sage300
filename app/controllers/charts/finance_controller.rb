class Charts::FinanceController < ApplicationController
  def income_vs_expenses
    render json: [
      { name: "Cost of Sales", data: Views::GeneralLedgerSummary.last_5_years.filter(params.slice(:start_date, :end_date)).cost_of_sales.group(:FSCSYR, :FSPERD).order(FSCSYR: :asc, FSPERD: :asc).sum(:AMOUNT) },
      { name: "Expenses", data: Views::GeneralLedgerSummary.last_5_years.filter(params.slice(:start_date, :end_date)).expenses.group(:FSCSYR, :FSPERD).order(FSCSYR: :asc, FSPERD: :asc).sum(:AMOUNT) },
      { name: "Revenues", data: Views::GeneralLedgerSummary.last_5_years.filter(params.slice(:start_date, :end_date)).revenue.group(:FSCSYR, :FSPERD).order(FSCSYR: :asc, FSPERD: :asc).sum("AMOUNT*-1") }
    ]
  end

  def net_income
    render json: Views::GeneralLedgerSummary.net_income.last_5_years.filter(params.slice(:start_date, :end_date)).group(:FSCSYR, :FSPERD).order(FSCSYR: :asc, FSPERD: :asc).sum("AMOUNT*-1")
  end

  def expenses_by_groups
    render json: Accpac::Glacgrp.select(:ACCTGRPCOD, :ACCTGRPDES).where("GRPCOD IN (170,180,190,200)").group(:ACCTGRPCOD, :ACCTGRPDES).map { |e|
      { 
        name: e.ACCTGRPDES, data: Views::GeneralLedgerSummary.last_5_years.filter(params.slice(:start_date, :end_date)).where(ACCTGRPCOD: e.ACCTGRPCOD).group(:FSCSYR, :FSPERD).order(FSCSYR: :asc, FSPERD: :asc).sum(:AMOUNT)
      }
    }
  end

  def expenses_by_account_groups
    render json: Views::GeneralLedgerSummary.last_5_years.where(ACCTGRPCOD: params[:id]).group(:FSCSYR, :FSPERD).order(FSCSYR: :asc, FSPERD: :asc).sum(:RAMOUNT)
  end

  def expenses_groups_by_years
    render json: Accpac::Glacgrp.select(:ACCTGRPCOD, :ACCTGRPDES).where("GRPCOD IN (170,180,190,200)").group(:ACCTGRPCOD, :ACCTGRPDES).map { |e|
      { 
        name: e.ACCTGRPDES, data: Views::GeneralLedgerSummary.by_years.where("ACCTGRPCOD = ? AND FSPERD <= ?", e.ACCTGRPCOD, current_period).group(:FSCSYR).order(FSCSYR: :asc).sum(:AMOUNT)
      }
    }
  end

  def cash_flow
    render json: Views::CashFlowSummary.last_2_years.group(:CNTYR, :CNTPERD).order(CNTYR: :asc, CNTPERD: :asc).sum("OPERCASH")
  end

  def cash_flow_detail
    render json: [
      { name: "Receipts", data: Views::CashFlowSummary.last_1_years.group(:CNTYR, :CNTPERD).order(CNTYR: :asc, CNTPERD: :asc).sum("RECEIPTS") },
      { name: "Payments", data: Views::CashFlowSummary.last_1_years.group(:CNTYR, :CNTPERD).order(CNTYR: :asc, CNTPERD: :asc).sum("PAYMENTS + SALARIES + INTERESTS") },
      { name: "Free Cash Flow", data: Views::CashFlowSummary.last_1_years.group(:CNTYR, :CNTPERD).order(CNTYR: :asc, CNTPERD: :asc).sum("OPERCASH") }
    ]
  end

  def aged_receivables
    @aged_ar = Views::UnpaidReceivable.find_by_sql(
      "SELECT
        SUM(CASE WHEN TERMDAYSOVER > 0 AND TERMDAYSOVER <= 30 THEN AMTDUEHC ELSE 0 END) AS [0-30],
        SUM(CASE WHEN TERMDAYSOVER > 30 AND TERMDAYSOVER <= 60 THEN AMTDUEHC ELSE 0 END) AS [31-60],
        SUM(CASE WHEN TERMDAYSOVER > 60 AND TERMDAYSOVER <= 90 THEN AMTDUEHC ELSE 0 END) AS [61-90],
        SUM(CASE WHEN TERMDAYSOVER > 90 THEN AMTDUEHC ELSE 0 END) AS [91+]
      FROM UnPaidReceivable"
    )

    @aged_ar.map do |a|
      render json: a
    end
  end

  def aged_payables
    @aged_ap = Views::UnpaidPayable.find_by_sql(
      "SELECT
        SUM(CASE WHEN TERMDAYSOVER > 0 AND TERMDAYSOVER <= 30 THEN AMTDUEHC ELSE 0 END) AS [0-30],
        SUM(CASE WHEN TERMDAYSOVER > 30 AND TERMDAYSOVER <= 60 THEN AMTDUEHC ELSE 0 END) AS [31-60],
        SUM(CASE WHEN TERMDAYSOVER > 60 AND TERMDAYSOVER <= 90 THEN AMTDUEHC ELSE 0 END) AS [61-90],
        SUM(CASE WHEN TERMDAYSOVER > 90 THEN AMTDUEHC ELSE 0 END) AS [91+]
      FROM UnPaidPayable"
    )

    @aged_ap.map do |a|
      render json: a
    end
  end
end
