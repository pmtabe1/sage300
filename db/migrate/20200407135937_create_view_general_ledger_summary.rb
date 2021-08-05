class CreateViewGeneralLedgerSummary < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists GeneralLedgerSummary
    SQL

    execute <<-SQL
      CREATE VIEW GeneralLedgerSummary AS
      SELECT g.ACCTGRPCOD, g.ACCTGRPDES, g.GRPCOD, a.ACCTID,
        a.ACCTFMTTD, a.ACCTDESC,fs.FSCSYR,
        SUM(fs.AMOUNT) AS AMOUNT, fs.FSPERD,
        EOMONTH(CONCAT(FSCSYR,FSPERD)+'01') AS DATE,
        CASE a.ACCTTYPE
          WHEN 'I' THEN 'Income Statement'
          WHEN 'B' THEN 'Balance Sheet'
          WHEN 'R' THEN 'Retained Earnings'
        END AS ACCTTYPE,
        CASE fs.CURNTYPE
          WHEN 'S' THEN 'Source'
          WHEN 'E' THEN 'Equivalent'
          WHEN 'F' THEN 'Functional'
        END AS CURNTYPE
      FROM GLACGRP g
      JOIN GLAMF a ON g.ACCTGRPCOD = a.ACCTGRPCOD
      JOIN FiscalSet fs ON a.ACCTID = fs.ACCTID
      WHERE FSCSDSG = 'A'
      GROUP BY g.ACCTGRPCOD, g.ACCTGRPDES, g.GRPCOD, a.ACCTID,
        a.ACCTFMTTD, a.ACCTDESC, a.ACCTTYPE, fs.FSCSYR, fs.FSPERD,
        fs.CURNTYPE
    SQL
  end
end
