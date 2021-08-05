class CreateViewCashFlowSummary < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists CashFlowSummary
    SQL

    execute <<-SQL
      CREATE VIEW CashFlowSummary AS
      SELECT cr.CNTYR, cr.CNTPERD, SUM((cr.AMTPAYMHC)*-1) AS RECEIPTS,
        (
          SELECT SUM(AMTINVPDHC)
          FROM APVSM
          WHERE CNTYR = cr.CNTYR
          AND CNTPERD = cr.CNTPERD
        ) AS PAYMENTS,
        (
          SELECT SUM(AMOUNT)
          FROM GeneralLedgerSummary
          WHERE FSCSYR = cr.CNTYR
          AND FSPERD = cr.CNTPERD
          AND ACCTGRPCOD = '1700'
        ) AS SALARIES,
        (
          SELECT SUM(AMOUNT)
          FROM GeneralLedgerSummary
          WHERE FSCSYR = cr.CNTYR
          AND FSPERD = cr.CNTPERD
          AND GRPCOD = 200
        ) AS INTERESTS,
        (
          SUM((cr.AMTPAYMHC)*-1) - 
          (SELECT SUM(AMTINVPDHC) FROM APVSM WHERE CNTYR = cr.CNTYR AND CNTPERD = cr.CNTPERD) - 
          (SELECT SUM(AMOUNT) FROM GeneralLedgerSummary WHERE FSCSYR = cr.CNTYR AND FSPERD = cr.CNTPERD AND ACCTGRPCOD = '1700') -
          (SELECT SUM(AMOUNT) FROM GeneralLedgerSummary WHERE FSCSYR = cr.CNTYR AND FSPERD = cr.CNTPERD AND GRPCOD = 200)
        ) AS OPERCASH
      FROM ARCSM cr
      GROUP BY cr.CNTYR, cr.CNTPERD
    SQL
  end
end
