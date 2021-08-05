class Accpac::PohstlController < ApplicationController
  before_action :authenticate_user!

  def purchases_analysis
    authorize! :purchases_analysis, Accpac::Pohstl
  end

  def vendors_analysis
    authorize! :purchases_analysis, Accpac::Pohstl
    @summary = Views::PurchasesAnalysis.find_by_sql("
      SELECT sa.VENDOR1,
      SUM(sa.NETSALES) AS NETSALES,
      SUM(sa.FCSTSALES) AS COSTSALES,
      SUM(sa.MARAMOUNT) AS MARGIN,
      (
          SELECT SUM(pa.NETPURCHASE)
          FROM PurchasesAnalysis pa
          WHERE pa.VENDOR = sa.VENDOR1
      ) AS NETPURCHASE,
      (
          SELECT SUM(i.TOTALCOST)
          FROM ItemLocationDetail i
          WHERE i.VENDOR1 = sa.VENDOR1
      ) AS INVENTORY,
      (
          SELECT SUM(AMTDUEHC)
          FROM UnPaidPayable due
          WHERE due.VENDORID = sa.VENDOR1
      ) AS DEBTS
      FROM SalesAnalysis sa
      GROUP BY sa.VENDOR1
    ")
  end
end
